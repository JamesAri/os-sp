#include <kth-finder.h>

namespace Kth_Finder
{
	namespace {
		bool less(int v, int w) {
			return v < w;
		}

		void exch(float a[], int i, int j) {
			const int t = a[i];
			a[i] = a[j];
			a[j] = t;
		}

		int partition(float a[], int lo, int hi) {
			int i = lo;
			int j = hi + 1;
			while (true) {
				while (i < hi && less(a[++i], a[lo]));
				while (j > lo && less(a[lo], a[--j]));
				if (i >= j) break;
				exch(a, i, j);
			}
			exch(a, lo, j);
			return j;
		}
	}

	float findKthLargest(float nums[], int size, int k) {
		int lo = 0;
		int hi = size - 1;
		while (hi > lo) {
			const int j = partition(nums, lo, hi);
			if (j < k) lo = j + 1;
			else if (j > k) hi = j - 1;
			else break;
		}
		return nums[k];
	}
}
