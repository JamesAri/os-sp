#pragma once

using int8_t = char;
using int16_t = short;
using int32_t = int;
using int64_t = long long;

using uint8_t = unsigned char;
using uint16_t = unsigned short;
using uint32_t = unsigned int;
using uint64_t = unsigned long long;

constexpr int32_t INT32_MAX = 0x7FFFFFFF; // 2147483647
constexpr int32_t INT32_MIN = 0x80000000; // -2147483648

constexpr uint32_t UINT32_MAX = 0xFFFFFFFF; // 4294967295
constexpr uint32_t UINT32_MIN = 0x00000000; // 0