#pragma once

#include <hal/intdef.h>

struct TUserspace_Heap_Chunk_Header
{
    TUserspace_Heap_Chunk_Header* prev;
    TUserspace_Heap_Chunk_Header* next;
    uint32_t size;
    bool is_free;
};