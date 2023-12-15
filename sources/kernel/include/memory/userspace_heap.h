#pragma once

#include <hal/intdef.h>

class CUserspace_Heap_Manager
{
    public:
        CUserspace_Heap_Manager();

        void* Alloc(uint32_t size);

		// TODO: dodelat uvolnovani pameti (muzeme zatim vynechat)
        // void Free(void* mem);
};

extern CUserspace_Heap_Manager sUserspaceMem;
