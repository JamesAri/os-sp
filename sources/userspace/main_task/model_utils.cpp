#include "model_utils.h"

namespace Model_Utils
{
	namespace {
		bool less(const float v, const float w) {
			return v < w;
		}

		void exch(TModel_Record *a, int i, int j) {
			const TModel_Record t = a[i];
			a[i] = a[j];
			a[j] = t;
		}

		int partition(TModel_Record *a, int lo, int hi) {
			int i = lo;
			int j = hi + 1;
			while (true) {
				while (i < hi && less(a[++i].fitness, a[lo].fitness));
				while (j > lo && less(a[lo].fitness, a[--j].fitness));
				if (i >= j) break;
				exch(a, i, j);
			}
			exch(a, lo, j);
			return j;
		}
	}

	void split_model(TModel_Record *records, int size, int k) {
		int lo = 0;
		int hi = size - 1;
		while (hi > lo) {
			const int j = partition(records, lo, hi);
			if (j < k) lo = j + 1;
			else if (j > k) hi = j - 1;
			else break;
		}
		// return records[k];
	}

	void copy_population(TModel_Record *dst, TModel_Record *src, int size)
	{
		for (int i = 0; i < size; ++i)
		{
			dst[i].chromosome = src[i].chromosome;
			dst[i].fitness = src[i].fitness;
		}
	}
}
