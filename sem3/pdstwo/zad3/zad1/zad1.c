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

// --- xoshiro256++ ---
/*
uint64_t rol64(uint64_t x, int k) { return (x << k) | (x >> (64 - k)); }

struct xoshiro256pp_state {
	uint64_t s[4];
} state;

uint64_t my_rand() {
	uint64_t *s = state.s;
	uint64_t const result = rol64(s[0] + s[3], 23) + s[0];
	uint64_t const t = s[1] << 17;

	s[2] ^= s[0];
	s[3] ^= s[1];
	s[1] ^= s[2];
	s[0] ^= s[3];

	s[2] ^= t;
	s[3] = rol64(s[3], 45);

	return result;
}
*/

int run_experiment(int n, bool d) {
	int *counts = calloc(n, sizeof(int));
	int empty = n;
	int one_ball = n;

	int max = 0;

	int k = 0;
	while (k <= n) {
		k++;
		int urn = 0;
		if (d) {
			int urn1 = my_rand() % n,
				urn2 = my_rand() % n;
			urn = counts[urn1] > counts[urn2] ? urn2 : urn1;
		} else {
			urn = my_rand() % n;
		}
		counts[urn]++;

		if (counts[urn] > max)
			max = counts[urn];
	}

	free(counts);

	return max;
}

int main(int argc, char *argv[]) {
	init_rand();

	bool one = false,
	     two = false;

	if (argc == 2) {
		if (!strcmp("1", argv[1]))
			one = true;
		else if (!strcmp("2", argv[1]))
			two = true;
		else if (!strcmp("all", argv[1]))
			one = two = true;
		else{
			fprintf(stderr, "Give argument (1|2|all) to run the simulations\n");
			return 1;
		}
	} else {
		fprintf(stderr, "Give argument (1|2|all) to run the simulations\n");
		return 1;
	}

	FILE *f;

	if (one) {
		f = fopen("wyniki1.csv", "w");

		if (!f) {
			printf("Nie można otworzyć pliku\n");
			return 1;
		}

		fprintf(f, "n,max\n");

		for (int n = 10000; n <= 1000000; n += 10000) {
			for (int rep = 1; rep <= 50; rep++) {
				int max = run_experiment(n, false);
				fprintf(f, "%d,%d\n", n, max);
			}
			printf("n = %d zrobione.\n", n);
		}

		fclose(f);
	}

	if (two) {
		f = fopen("wyniki2.csv", "w");

		if (!f) {
			printf("Nie można otworzyć pliku\n");
			return 1;
		}

		fprintf(f, "n,max\n");

		for (int n = 10000; n <= 1000000; n += 10000) {
			for (int rep = 1; rep <= 50; rep++) {
				int max = run_experiment(n, true);
				fprintf(f, "%d,%d\n", n, max);
			}
			printf("n = %d zrobione.\n", n);
		}

		fclose(f);
	}

	return 0;
}
