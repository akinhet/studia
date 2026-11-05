#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

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


int run_experiment(int n, int p)
{
	int t = 0,
	    j = n;

	while (j > 0) {
		int diff = 0;
		t++;

		for (int i = 1; i <= j; i++) {
			if (my_rand() % p == 0)
				diff++;
		}
		j -= diff;
	}

	return t;
}


int main(int argc, char *argv[]) {
	init_rand();

	FILE *f;

	f = fopen("wyniki.csv", "w");

	if (!f) {
		printf("Nie można otworzyć pliku\n");
		return 1;
	}

	fprintf(f, "n,T\n");

	for (int n = 1000; n <= 100000; n += 1000) {
		for (int rep = 1; rep <= 50; rep++) {
			int t = run_experiment(n, 2);
			fprintf(f, "%d,%d\n", n, t);
		}
		printf("n = %d zrobione.\n", n);
	}

	fclose(f);

	return 0;
}
