#include <stdio.h>
#include <stdlib.h>

static int num_good_boards = 0;


void eval_board(int a[], int n)
{
	for (int i = 0; i < n - 1; i++)
		for (int j = i + 1; j < n; j++) {
			if (a[j] == a[i] + j - i || a[j] == a[i] - j + i)
				return;
		}

	for (int i = 0; i < n; i++)
		printf("%d ", a[i]);
	printf("\n");

	num_good_boards++;
}


void gen_permutations(int a[], int size, int n)
{
	if (size == 0) {
		eval_board(a, n);
		return;
	}

	for (int i = 0; i < size; i++) {
		gen_permutations(a, size - 1, n);

		if (size % 2 == 1) {
			int temp = a[0];
			a[0] = a[size - 1];
			a[size - 1] = temp;
		} else {
			int temp = a[i];
			a[i] = a[size - 1];
			a[size - 1] = temp;
		}
	}
}


int main(int argc, char **argv)
{
	if (argc != 2) {
		printf("Usage: %s [number of queens]\n", argv[0]);
		return 1;
	}
	
	int n = 0;
	sscanf(argv[1], "%d", &n);
	if (n <= 0) {
		printf("ERROR: bad argument: %s\n", argv[1]);
		return 2;
	}

	int *a = (int*) malloc(sizeof(int) * n);

	for (int i = 0; i < n; i++)
		a[i] = i + 1;

	gen_permutations(a, n, n);

	printf("Numer of solutions: %d\n", num_good_boards);
}
