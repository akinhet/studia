#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>
#include <bits/time.h>
#include "init.h"


// uint64_t x = 0, w = 0, s = 0xb5ad4eceda1ce2a9;
uint64_t x, w, s;

static void init_rand() {
	struct timespec ts;
	clock_gettime(CLOCK_MONOTONIC, &ts);
	x = w = s = init_rand_digits(ts.tv_nsec ^ ts.tv_sec);
}

inline static uint32_t my_rand() {
  x *= x;
  x += (w += s);
  return x = (x >> 32) | (x << 32);
}


int main(int argc, char *argv[])
{
	if (argc != 3 && argc != 4) {
		return 1;
	}

	int m = atoi(argv[1]);
	int n = atoi(argv[2]);

	int **matrix = (int **)malloc(m * sizeof(int *));
	for (int i = 0; i < m; i++) {
		matrix[i] = (int *)malloc(n * sizeof(int));
	}

	init_rand();

	for (int i = 0; i < m; i++) {
		for (int j = 0; j < n; j++) {
			int min_val = 0;
			
			if (i > 0 && j > 0) {
				min_val = (matrix[i-1][j] > matrix[i][j-1]) ? matrix[i-1][j] : matrix[i][j-1];
			} else if (i > 0) {
				min_val = matrix[i-1][j];
			} else if (j > 0) {
				min_val = matrix[i][j-1];
			} else {
				min_val = 0;
			}
			
			matrix[i][j] = min_val + (my_rand() % 10) + 1;
		}
	}

	printf("%d %d", m, n);
	for (int i = 0; i < m; i++) {
		for (int j = 0; j < n; j++) {
			printf(" %d", matrix[i][j]);
		}
	}
	// printf(" %d", (argc == 4) ? atoi(argv[3]) : (my_rand() % matrix[m-1][n-1]));
	printf(" %d", (argc == 4) ? atoi(argv[3]) : matrix[0][n-1]);
	printf("\n");

	for (int i = 0; i < m; i++) {
		free(matrix[i]);
	}
	free(matrix);

	return 0;
}
