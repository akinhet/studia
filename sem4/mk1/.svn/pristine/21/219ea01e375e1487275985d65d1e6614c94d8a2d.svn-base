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


void merge(int* arr, int left, int mid, int right)
{
	int n1 = mid - left + 1;
	int n2 = right - mid;

	int* L = (int*)malloc(n1 * sizeof(int));
	int* R = (int*)malloc(n2 * sizeof(int));

	for (int i = 0; i < n1; i++) {
		move(&L[i], &arr[left + i]);
	}
	for (int j = 0; j < n2; j++) {
		move(&R[j], &arr[mid + 1 + j]);
	}

	int i = 0, j = 0, k = left;

	while (i < n1 && j < n2) {
		if (!compare(L[i], R[j], more)) {
			move(&arr[k++], &L[i++]);
		} else {
			move(&arr[k++], &R[j++]);
		}
	}

	while (i < n1) {
		move(&arr[k++], &L[i++]);
	}

	while (j < n2) {
		move(&arr[k++], &R[j++]);
	}

	free(L);
	free(R);
}


void merge_sort_recursive(int* arr, int left, int right)
{
	if (left < right) {
		int mid = left + (right - left) / 2;

		merge_sort_recursive(arr, left, mid);
		merge_sort_recursive(arr, mid + 1, right);

		merge(arr, left, mid, right);
	}
}


void sort(int* arr, int n)
{
	if (n <= 1) return;
	merge_sort_recursive(arr, 0, n - 1);
}


int main(int argc, char** argv) {
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
