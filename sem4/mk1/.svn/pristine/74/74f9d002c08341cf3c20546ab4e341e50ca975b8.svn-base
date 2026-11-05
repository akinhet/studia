#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

typedef enum { less, more, equal } compareType;

int comparisons = 0;
bool compare(int a, int b, compareType type)
{
	comparisons++;
	switch (type) {
		case less:
			return a < b;
		case more:
			return a > b;
		case equal:
			return a == b;
	}

	return false;
}


int moves = 0;
void move(int *a, int *b)
{
	moves++;
	int temp = *a;
	*a = *b;
	*b = temp;
}


void printArr(int arr[], int n)
{
	for (int i = 0; i < n; i++) {
		printf("%d ", arr[i]);
	}
	printf("\n");
}


int switchalg = 11;


void insertionsort(int arr[], int n)
{
	int i, key, j;
	for (i = 1; i < n; i++) {
		key = arr[i];
		j = i - 1;
		while (j >= 0 && compare(arr[j], key, more)) {
			move(&arr[j+1], &arr[j]);
			j = j - 1;
		}
		// move(&arr[j+1], key);
	}
}


void quicksort(int *arr, int start, int end, int n)
{
	if (end <= start) return;

	if (end - start < switchalg) {
		insertionsort(&arr[start], end - start + 1);
		if (n < 40)
			printArr(arr, n);
		return;
	}

	int i = start - 1,
	    j = end + 1,
	    pivot = arr[(start+end)/2];

	while (true) {
		while (compare(pivot, arr[++i], more));
		while (compare(pivot, arr[--j], less));

		if (i <= j)
			move(&arr[i], &arr[j]);
		else
			break;
	}

	if (n < 40)
		printArr(arr, n);

	if (j > start)
		quicksort(arr, start, j, n);
	if (i < end)
		quicksort(arr, i, end, n);
}


void sort(int arr[], int n)
{
	quicksort(arr, 0, n-1, n);
}


int main(int argc, char** argv) {
	if (argc == 2)
		switchalg = atoi(argv[1]);

	int n;

	if (scanf("%d", &n) != 1) {
		return 2;
	}

	if (n <= 0)
		return 2;

	int *input = malloc(n * sizeof(int));
	int *arr = malloc(n * sizeof(int));
	if (arr == NULL || input == NULL)
		return 1;

	for (int i = 0; i < n; i++) {
		if (scanf("%d", &input[i]) != 1) {
			return 1;
		}
	}
	memcpy(arr, input, n*sizeof(int));

	if (n < 40) {
		printf("Input: ");
		printArr(input, n);
	}

	sort(arr, n);

	for (int i = 1; i < n; i++)
		if (arr[i-1] > arr[i]) {
			printf("ERROR: %d\n", i);
			return 3;
		}

	if (n < 40) {
		printf("Input:  ");
		printArr(input, n);
		printf("Output: ");
		printArr(arr, n);
	}

	printf("moves: %d, compares: %d\n", moves, comparisons);

	free(arr);
	return 0;
}
