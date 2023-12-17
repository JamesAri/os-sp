#include <memory/userspace_heap.h>
#include <memory/pages.h>
#include <process/process_manager.h>
#include <memory/mmu.h>

// TODO REMOVE
#include <drivers/uart.h>

CUserspace_Heap_Manager sUserspaceMem;

CUserspace_Heap_Manager::CUserspace_Heap_Manager()
{
	//
}

void* CUserspace_Heap_Manager::Alloc(uint32_t increment)
{
	sUART0.Write("Allocating ");
	sUART0.Write_Hex(increment);
	sUART0.Write(" bytes\r\n");

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
		sUART0.Write("Enough free memory\r\n");
		task->heap_logical_break += increment;
		return reinterpret_cast<void*>(prev_heap_logical_break);
	}

	// nemame dostatek volneho mista ve strance, potrebujeme tak vytvorit nove stranky (minimalne jednu)
	uint32_t num_of_needed_pages = (increment - free_memory) / mem::PageSize;

	sUART0.Write("Not enough free memory\r\n");
	sUART0.Write("Num of needed pages: ");
	sUART0.Write(num_of_needed_pages);
	sUART0.Write("\r\n");
	
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