#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

typedef struct {
	int* data;
	int size;
} Run;

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
	*a = *b;
}


void printArr(int arr[], int n)
{
	for (int i = 0; i < n; i++) {
		printf("%d ", arr[i]);
	}
	printf("\n");
}


Run* find_runs(int* arr, int n, int* num_runs)
{
	Run* runs = (Run*)malloc(n * sizeof(Run));
	int count = 0;
	int start = 0;
	
	for (int i = 1; i < n; i++) {
		if (compare(arr[i], arr[i - 1], less)) {
			runs[count].size = i - start;
			runs[count].data = (int*)malloc(runs[count].size * sizeof(int));
			for (int j = 0; j < runs[count].size; j++) {
				move(&runs[count].data[j], &arr[start + j]);
			}
			count++;
			start = i;
		}
	}
	
	runs[count].size = n - start;
	runs[count].data = (int*)malloc(runs[count].size * sizeof(int));
	for (int j = 0; j < runs[count].size; j++) {
		move(&runs[count].data[j], &arr[start + j]);
	}
	count++;
	
	*num_runs = count;
	return runs;
}


Run merge(Run left, Run right)
{
	Run result;
	result.size = left.size + right.size;
	result.data = (int*)malloc(result.size * sizeof(int));
	
	int i = 0, j = 0, k = 0;
	
	while (i < left.size && j < right.size) {
		if (!compare(left.data[i], right.data[j], more)) {
			move(&result.data[k++], &left.data[i++]);
		} else {
			move(&result.data[k++], &right.data[j++]);
		}
	}
	
	while (i < left.size)
		move(&result.data[k++], &left.data[i++]);
	while (j < right.size)
		move(&result.data[k++], &right.data[j++]);
	
	free(left.data);
	free(right.data);
	
	return result;
}


Run merge_runs(Run* runs, int start, int end)
{
	if (start == end) {
		return runs[start];
	}
	
	int mid = start + (end - start) / 2;
	
	Run left_merged = merge_runs(runs, start, mid);
	Run right_merged = merge_runs(runs, mid + 1, end);
	
	return merge(left_merged, right_merged);
}


void mysort(int* arr, int n)
{
	if (n <= 1) return;
	
	int num_runs = 0;
	
	Run* runs = find_runs(arr, n, &num_runs);
	
	Run final_run = merge_runs(runs, 0, num_runs - 1);
	
	for (int i = 0; i < n; i++) {
		arr[i] = final_run.data[i];
	}
	
	free(final_run.data);
	free(runs);
}


int main(int argc, char** argv)
{
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

	mysort(arr, n);

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
