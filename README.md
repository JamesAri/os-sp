## Úvod

Jméno: Jakub Šlechta (A23N0026P)
Zadání: **Single-task výpočet**
Zařízení: **Reálné** Raspberry Pi Zero
Kostra OS: KIV-RTOS

V bodech:
- vytvořit právě jeden user-space task, který bude zaštiťovat níže popsaný výpočet
- task po spuštění vypíše na UART základní informace o práci
- task čte z UARTu parametry a vstupní data v textové podobě, každé zadání je ukončeno zalomením řádku
- jako první vstup bude celé číslo, které označuje časový rozestup `t_delta` hodnot časové řady v minutách - tedy vlastně po jakých číslech se krokuje na ose X
- jako další vstup bude celé číslo, které označuje predikční okénko `t_pred` - tedy parametr modelu, viz níže
- jako každý další vstup bude číslo s plovoucí desetinnou tečkou nebo příkaz "stop" nebo "parameters"
	- zde jsem si zadání rozšířil o následující příkazy: 

```
Available commands: "time", "lookup", "stop", "parameters", "reset", "retrain", "debug"

lookup - prints current lookup table (saved values) 
time - prints current time (the last value in the lookup table corresponds to this time) 
stop - stops training phase and rollbacks one delta time (removes last value from lookup table) 
parameters - prints current model parameters
reset - resets the model (keeps lookup table, current time, prediction window, time delta) 
retrain - retrain the model with current data and population 
debug - prints debug commands
```

```
Available commands for debugging: "compare", "settings"   

compare - prints the difference (absolute value) between predicted and actual value for each time in the lookup table 
settings - prints current model settings`
```

- task provede po každém přijatém čísle fitting modelu `y(t + t_pred) = A * b(t) + B * b(t) * (b(t) - y(t)) + C`, kde `b(t)` spočítáte jako: `b(t) = D/E * dy(t)/dt + 1/E * y(t)`
- `A,B,C,D,E` jsou parametry modelu (modelů)
- řešeno evoluční strategií, bez nmč
- jako odpověď na přijaté číslo task vypíše novou predikci `y(t + t_pred)` dle nově spočtených parametrů, popř. řetězec s instrukcemi co dělat, pokud ještě není možné predikovat
- UART terminál musí být během výpočtu rozumně responzivní
	- kdykoliv probíhá výpočet, musí ho být možné zastavit zadáním příkazu `stop`
	- -pokud je výpočet ukončen, predikce je spočtena dle starých parametrů
- pokud zrovna neprobíhá výpočet, zařízení minimalizuje spotřebu el. energie
-  task si vyžádá paměť POUZE při své inicializaci (z userspace haldy)
- vstupy jsou validovány
## Analýza a řešené problémy

Nyní se pokusím v bodech popsat veškeré problémy, které bylo třeba vyřešit:

- čtení z UARTu
	- kernel podpora (cyklickým) bufferem kvůli "omezení" zařízení
	- zavedení systémového volání
- výpis na UART
- generování náhodných čísel
	- celých, reálných
- dynamická paměť u userspace tasků (sbrk sys call)
- čekání na příkazy během výpočtu
- FPU support
- predikce/fitting modelu (mnč x GA/EA/ES/...)
- minimalizace spotřeby el. energie
- operace nad řetězci
	- parsování - float to ascii, ascii to float, int to ascii, ascii to int
	- a další různé potřebné operace - kontrola zda je řetězec float/int, strcspn, ....
- (v případe reálného HW) - platformní závislosti (konce řádků)
- nutná optimalizace při použití GA/EA/ES/..., jelikož jsme na nízkopříkonovém zařízení, kde máme navíc vypnuté optimalizace od překladače (netriviální výpočet musí být dokončen v rozumně omezeném čase)
	- např. použití optimálního algoritmu pro nalezení top N prvků v populaci

<div style="page-break-after: always;"></div>

## Implementace

V této části popíšu jak jsem zmíněné problémy řešil.
(předem se omlouvám za mix angličtiny a češtiny u komentářů)

#### Čtení z UARTu

Jako první byla potřeba vytvořit kernel buffer, do kterého budeme ukládat přijaté znaky:

```cpp
constexpr uint32_t Message_Queue_Size = 4096;

class CCircularBuffer {
    private:
        char mBuffer[Message_Queue_Size];
        uint32_t mHead;  // Index začátku bufferu
        uint32_t mTail;  // Index konce bufferu
        bool mFull;      // Indikátor, zda je buffer plný

    public:
        CCircularBuffer();

        void Push(char value);

        char Pop();

        bool Empty() const;

        bool Full() const;

		char Peek() const;
};
```

implementaci vynechám, jelikož si myslím,  že je v celku přímočará.

Dále lze problém čtení z UARTu rozložit do následujících definic:

```cpp
char Read(); // volano z obsluhy sys callu

bool Empty(); // kontrola, zda je co cist

void IRQ_Callback(); // miniUART irq handler

bool Is_UART_IRQ_Pending(); // podminka, ktera musi byt splnena pro zavolani IRQ_Callback

void Enable_IRQ(); // povoli receive IRQ miniUARTu

// TODO: allow multiple files to wait for receive event
void Wait_For_Receive_Event(IFile *file);
```

Co by zde bylo dobré ukázat je implementace `IRQ_Callback`:

```cpp
void CUART::IRQ_Callback() 
{
	if(Data_Ready())
	{
		const char received_char = Read_Internal();
		mCircular_Buffer.Push(received_char);
		// TODO: Won't work well on Windows (\r\n) rn (pun intended)
		if (mWaiting_File && (received_char == '\r' || received_char == '\n'))
		{
			mWaiting_File->Notify(1);
		}
	}
	
	// pokud by Data_Ready vracelo false (coz by se stat nemelo), tak i presto 
	// premazeme receive buffer, aby se IRQ neopakovalo stale dokola.
	Clear_Receive_Buffer();
}
```

jak je zde vidět, UART driver probudí proces v případě, že obdržel znak, který naznačuje konec řádku. Tohle není asi úplně správně, jelikož předpokládáme "textový" přenos, ale v tomto případě to značně ušetří na složitosti a zlepší úsporu energie zařízení.

Dále musíme umožnit procesu čekat nad UARTem, to zajistíme implementací metody `Wait` rozhraní `IFIle` u UART fs driveru:

*uart_fs.h*:

```cpp
virtual bool Wait(uint32_t _count) override
{
	// pokud mame co cist, neblokujeme proces
	if (sUART0.Empty()) {
		Wait_Enqueue_Current();
		sUART0.Wait_For_Receive_Event(this);
		
		// zablokujeme, probudi nas az notify 
		sProcessMgr.Block_Current_Process();
	}
	return true;
}
```

pozn.: zde je opět možnost pro zlepšení - například mutex a kontrola, zda je soubor pro daný proces otevřený, pokud UART povoluje pouze jeden čekající proces.

Nyní už jen potřebujeme přidat `IRQ_Callback` do obsluhy přerušení:

*interrupt_controller.cpp* (`_internal_irq_handler`):

```cpp
if (sUART0.Is_UART_IRQ_Pending())
	sUART0.IRQ_Callback();
```

#### Výpis na UART

Hotové z KIV-RTOS kostry.

#### Generování náhodných čísel

Generování celých čísel je již v podstatě hotové v kostře KIV-RTOS, jediné co bylo třeba dodělat je rozšíření o nějaký range.

Generování reálných čísel:

```cpp
// Returns a random float between min and max, (min inclusive, max inclusive)
float get_random_float(uint32_t trng_file, float min, float max)
{
    uint32_t random_int = get_random_uint32(trng_file);

    // Convert the random integer to a floating-point number between 0 and 1
    float random_normalized = (float)random_int / UINT32_MAX;

    // Scale the random number to the desired range
    float random_in_range = min + (max - min) * random_normalized;

	return random_in_range;
}
```

#### Userspace halda (sbrk sys call)

Zde rovnou ukáži kompletní implementaci alokace pro userspace procesy:

*sources/kernel/src/memory/userspace_heap.cpp*:

```cpp
void* CUserspace_Heap_Manager::Alloc(uint32_t increment)
{
	if (increment > mem::MaxProcessHeapSize)
	{
		return nullptr;
	}

	TTask_Struct *task = sProcessMgr.Get_Current_Process();

	if (task == nullptr)
	{
		return nullptr;
	}

	// ziskame virtualni adresu tabulky stranek
	uint32_t *pt = reinterpret_cast<uint32_t*>((task->cpu_context.ttbr0 + mem::MemoryVirtualBase) & ~3);

	// check prvni alokace
	if (task->heap_current_block_start == mem::PageNotInitialized)
	{
		// alokujeme prvni stranku
		uint32_t new_kernel_page_virt = sPage_Manager.Alloc_Page();
		if (new_kernel_page_virt == 0)
		{
			return nullptr;
		}
		// zapiseme novou stranku do tabulky stranek
		uint32_t new_page_phys = new_kernel_page_virt - mem::MemoryVirtualBase;
		map_memory(pt, new_page_phys, mem::HeapPageMemory);
		task->heap_current_block_start = mem::HeapPageMemory;
		task->heap_logical_break = mem::HeapPageMemory;
	}

	// kontrola, jestli se vejdeme do max povolene pameti
	if ((increment + (task->heap_logical_break - mem::HeapPageMemory)) > mem::MaxProcessHeapSize)
	{
		return nullptr;
	}

	uint32_t free_memory = mem::PageSize - (task->heap_logical_break - task->heap_current_block_start);

	uint32_t prev_heap_logical_break = task->heap_logical_break;

	// inkrement se stale vejde do aktualni stranky
	if (increment <= free_memory)
	{
		task->heap_logical_break += increment;
		return reinterpret_cast<void*>(prev_heap_logical_break);
	}

	// nemame dostatek volneho mista ve strance, potrebujeme tak vytvorit nove stranky (minimalne jednu)
	uint32_t num_of_needed_pages = (increment - free_memory) / mem::PageSize;
	
	if ((increment - free_memory) % mem::PageSize != 0)
	{
		num_of_needed_pages++;
	}

	for (uint32_t i = 0; i < num_of_needed_pages; i++)
	{
		uint32_t new_kernel_page_virt = sPage_Manager.Alloc_Page();
		if (new_kernel_page_virt == 0)
		{
			return nullptr;
		}

		// zapiseme novou stranku do tabulky stranek
		uint32_t new_page_phys = new_kernel_page_virt - mem::MemoryVirtualBase;
		uint32_t new_userspace_page_virt = task->heap_current_block_start + mem::PageSize;
		map_memory(pt, new_page_phys, new_userspace_page_virt);
		// nastavime novy zacatek bloku
		task->heap_current_block_start = new_userspace_page_virt;
		sUART0.Write("Allocated new page: ");
		sUART0.Write_Hex(new_userspace_page_virt);
		sUART0.Write("\r\n");

	}

	task->heap_logical_break += increment;

	return reinterpret_cast<void*>(prev_heap_logical_break);
}
```

Jak je z implementace vidět, v našem "task PCB" přibylo `heap_current_block_start` pro indikaci dolní adresy poslední alokované stránky a `heap_logical_break` pro indikaci, kde se v poslední alokované stránce aktuálně nacházíme (to pak také vrací `sbrk`) - viz cvičení

Při vytváření nového procesu musíme nastavit zarážky:

*process_manager.cpp* (`Create_Process`):

```cpp
// nastavime logicke zarazky na neinicializovane
task->heap_current_block_start = mem::PageNotInitialized;
task->heap_logical_break = mem::PageNotInitialized;
```

Pak už jen musíme zavést systémové volání a vytvořit pro to podporu (`sbrk`) ve standardní knihovně:

*swi.h* (`NSWI_Process_Service`):

```cpp
// pozadavek na alokaci pameti
// IN: r0 = pozadovany inkrement alokovane pameti
// OUT: r0 = ukazatel na zacatek alokovane pameti nebo nullptr pokud alokace selhala
Sbrk			= 6,
```

*process_manager.cpp* (`Handle_Process_SWI`):

```cpp
case NSWI_Process_Service::Sbrk:
{
	uint32_t increment = r0;
	void *alloc_mem_bp = sUserspaceMem.Alloc(increment);
	target.r0 = reinterpret_cast<uint32_t>(alloc_mem_bp);
	break;
}
```

*stdmemory.cpp*:

```cpp
void *sbrk(uint32_t increment)
{
	void *retaddr = nullptr;

	asm volatile("mov r0, %0" : : "r" (increment));
	asm volatile("swi 6");
	asm volatile("mov %0, r0" : "=r" (retaddr));

	return retaddr;
}
```

#### Čekání na příkazy během výpočtu

Po každé iteraci (vygenerování nové populace) se pouze zkontroluje, zda něco není na vstupu. Kód je poměrně rozsáhlý a nezajímavý, proto ho vynechám. 

Popř.: *sources/userspace/main_task/main.cpp* (`check_for_stop_command`)

#### FP coprocessor support

*start.s* (`_reset`):

```assembly
;@ nastavime FP coprocessor
mrc p15, 0, r0, c1, c0, 2
orr r0, r0, #0x300000
mcr p15, 0, r0, c1, c0, 2
mov r0, #0x40000000
fmxr fpexc,r0
```

#### Predikce (fitting) modelu

Použil jsem evoluční stragii bez mnč:

![[Pasted image 20231220185436.png]]

#### Minimalizace spotřeby el. energie

V kostře KIV-RTOS je již ukázka tasku *init_task*, který kontroluje, zda není jediný co může běžet a pokud ano, tak zavolá instrukci `wfe`, kterou již dobře známe.

V mém případě poběží pouze jeden proces, který se bude blokovat nad UARTem a *init_task* proces, který v momentě, kdy je hlavní task zablokovaný zavolá již zmiňovanou instrukci.

Hlavní proces je zablokovaný, pokud čeká na user input (tedy neprobíhá výpočet).

#### Operace nad řetězci

Pouze zde zmíním přidané funkce do *stdstring* knihovny, které jsem potřeboval (bez implementace):

```cpp
float atof(const char* s); // ascii to float
void ftoa(float x, char *bfr); // float to ascii
void ftoa(float x, char *bfr, const unsigned int decimals); // ftoa with precision
unsigned int strcspn(const char* str1, const char* str2); // get span until character in string
int strncmp(const char *s1, const char *s2); // compare fn
bool is_float(char *str); // check if string is float
bool is_int(char *str); // check if string is int
```

#### Platformní závislosti (konce řádků)

Upřímně se přiznám, že jsem zkoušel komunikovat pouze linux-rpi0, ale snažil jsem se, aby komunikace byla nezávislá na platformě.

Příklad odstranění závislosti např. takto:

```cpp
receive_buffer[strcspn(receive_buffer, "\r\n")] = '\0'; // remove LF, CR, CRLF, LFCR, ..
```

#### Optimalizace

Jak již bylo zmíněno, nacházíme se na nízkopříkonovém zařízení, kde máme navíc vypnuté optimalizace od překladače. Tento netriviální výpočet tak musí být dokončen v rozumně omezeném čase, a proto většinu času jsem strávil pravě nad optimalizacemi (implementace kernel oriented věcí cca 10% času, zbytek řešení výpočtu a optimalizace).

Jelikož tato SP měla být o operačních systémech, nebudu zde dopodrobna rozebírat řešení evoluční strategií, ale pouze vyzdvihnu pro mne zajímavé části.

První jsem si vytvořil pomocnou funkci pro měření počtu tiků časovače, která nějaká funkce spotřebuje:

```cpp
// Tics in comments measured on Pop_Size = 10000 and Iterations = 100
// used for optimizing - measures duration (tics) of the callback fn 
void print_duration(void (*callback)(), const char *msg)
{
	char string_buffer[32];
	bzero(string_buffer, 32);
	
	uint32_t start, end;
	start = get_tick_count();
	callback();
	end = get_tick_count();

	fputs(uart_file, msg);
	fputs(uart_file, end - start);
}
```

Generování nové generace pak vypadalo nějak takto:

```cpp
void next_generation()
{	
	// Copy new population to old population array:
	print_duration(copy_population, "copy_population duration: ");

	// Since new population got copied to the old one, we need to swap the fitness pointers.
	// Swap the new fitness pointer with the old fitness pointer:
	// fitness vector before: [-----fitness_old-----|-----fitness_new-----]
	// fitness vector after:  [-----fitness_new-----|-----fitness_old-----]
	// the [-----fitness_new-----] will be overwritten in next steps.
	print_duration(swap_fitness_vectors, "swap_fitness_vectors duration: ");

	// Crossover the new population
	print_duration(crossover, "crossover duration: ");

	// Mutate the new population
	print_duration(mutate, "mutate duration: ");

	// Calculate fitness for the new population
	print_duration(calculate_fitness_optimized, "calculate_fitness_optimized duration: ");

	// Select the best chromosomes from old + new population
	print_duration(select, "select duration: ");
}
```

kde jsem postupně jednotlivé části generování populace upravoval. Podrobnější detaily o optimalizacích jsem zanechal v komentářích, např. u `crossover` funkce:

```cpp
// 170 tics
void crossover()
{	
	// Optimization: generate one random parameter index for the whole population and 
	// use the for-loop index as an offset - [900 tics to 170 tics]
	const unsigned int rnd_index = get_random_param_index();
	
	// ...
```

Jednou pro mne zajímavou optimalizací bylo použití quickselectu pro nalezení mediánu fitness vektoru. Vytvořil jsem fitness vektor, který patřil z první poloviny buďto staré nebo nové populaci a z druhé poloviny té druhé populaci:

```cpp
// Fitness_Vector_Size = 2 * Pop_Size
fitness = static_cast<float*>(sbrk(Fitness_Vector_Size * sizeof(float)));
fitness_new = fitness;
fitness_old = fitness_new + Pop_Size;
```

V ukázce o generování nové populace je komentář u `swap_fitness_vectors`, který popisuje prohození `fitness_new` pointru a `fitness_old` pointru (aby se redukovalo zbytečné kopírování).

Důvod, proč se nám hodí mít tyto dva vektory za sebou je právě využití quickselectu pro nalezení mediánu. To nám umožní ze staré a nové populace vybrat ty nejlepší chromozomy do nové populace a to (v běžném případě) v O(n) čase.

## Testování

Vytvořil jsem několik funkcí, které přes UART testují funkčnost jednotlivých částí systému (těch, které jsem samostatně dodělával).

Nechám zde odkaz na repozitář. Měla by tam být demo branch, kde jsme zanechal různé výpisy ve zdrojácích kernelu: [GitHub - JamesAri/os-sp at demo](https://github.com/JamesAri/os-sp/tree/demo)

## Závěr

Výsledkem práce by mělo být především rozšíření kostry KIV-RTOS o userspace haldu, funkční čtení z miniUARTu, povolení FP coprocesoru, doplnění některých std implementací a vytvoření userspace tasku pro predikci hladin glukózy v intersticiální tekutině.

Myslím, že jsem zadání splnil, ale jak již bylo výše zmíněno, našlo by se v práci několik míst pro zlepšení.
