#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

typedef struct {
	int cmp,
	    s;
} result_t;

// --- msws32 ---
#include "init.h"
#include <time.h>

// uint64_t x = 0, w = 0, s = 0xb5ad4eceda1ce2a9;
uint64_t x, w, s;

static void init_rand() { x = w = s = init_rand_digits(time(NULL)); }

inline static uint32_t my_rand() {
	x *= x;
	x += (w += s);
	return x = (x >> 32) | (x << 32);
}


result_t run_experiment(int n)
{
	int *arr = calloc(n, sizeof(int));
	int cmp = 0,
	    s = 0;

	for (int i = 0; i < n; i++) {
		arr[i] = i;
	}

	for (int i = n - 1; i >= 0; i--) {
		int j = my_rand() % (i + 1);
		int temp = arr[i];
		arr[i] = arr[j];
		arr[j] = temp;
	}

	for (int i = 1; i < n; i++) {
		int key = arr[i];
		int j = i - 1;
		while (j >= 0) {
			cmp++;
			if (arr[j] > key) {
				s++;
				arr[j + 1] = arr[j];
				j = j - 1;
			} else 
				break;
		}
		s++;
		arr[j + 1] = key;
	}

	result_t r = {0};
	r.cmp = cmp;
	r.s = s;

	return r;
}


int main(int argc, char *argv[]) {
	init_rand();

	FILE *f;

	f = fopen("wyniki.csv", "w");

	if (!f) {
		printf("Nie można otworzyć pliku\n");
		return 1;
	}

	fprintf(f, "n,cmp,s\n");

	for (int n = 100; n <= 10000; n += 100) {
		for (int rep = 1; rep <= 50; rep++) {
			result_t r = run_experiment(n);
			fprintf(f, "%d,%d,%d\n", n, r.cmp, r.s);
		}
		printf("n = %d zrobione.\n", n);
	}

	fclose(f);

	return 0;
}
