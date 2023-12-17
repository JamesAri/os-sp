#pragma once

#include "model_defs.h"

namespace Model_Utils
{
	// splits model into two parts: [0, k] and [k + 1, size - 1]
	// where [0, k] is less than [k + 1, size - 1]
	void split_model(TModel_Record *records, int size, int k);
	void copy_population(TModel_Record *dst, TModel_Record *src, int size);
}
