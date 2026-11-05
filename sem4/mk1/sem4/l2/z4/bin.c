#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>


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


bool search(int **matrix, int m, int n, int target)
{
	if (m == 0 || n == 0) return false;

	if (m < n) {
		for (int i = 0; i < m; i++) {
			// if (compare(matrix[i][0], target, more))
			// 	return false;

			int left = 0,
			    right = n - 1;

			while (left <= right) {
				int mid = (left + right) / 2;

				if (compare(matrix[i][mid], target, equal))
					return true;
				else if (compare(matrix[i][mid], target, less))
					left = mid + 1;
				else
					right = mid - 1;
			}
		}
	} else {
		for (int i = 0; i < n; i++) {
			// if (compare(matrix[0][i], target, more))
			// 	return false;

			int left = 0,
			    right = m - 1;

			while (left <= right) {
				int mid = (left + right) / 2;

				if (compare(matrix[mid][i], target, equal))
					return true;
				else if (compare(matrix[mid][i], target, less))
					left = mid + 1;
				else
					right = mid - 1;
			}
		}
	}

	return false;
}


int main()
{
	int m, n, target;

	if (scanf("%d %d", &m, &n) != 2) {
		return 1;
	}

	int **matrix = (int **)malloc(m * sizeof(int *));
	for (int i = 0; i < m; i++) {
		matrix[i] = (int *)malloc(n * sizeof(int));
	}

	for (int i = 0; i < m; i++) {
		for (int j = 0; j < n; j++) {
			if (scanf("%d", &matrix[i][j]) != 1) {
				return 1;
			}
		}
	}

	if (scanf("%d", &target) != 1) {
		target = 0; 
	}

	if (search(matrix, m, n, target)) {
		printf("true\n");
	} else {
		printf("false\n");
	}
	printf("compares: %d\n", comparisons);

	for (int i = 0; i < m; i++) {
		free(matrix[i]);
	}
	free(matrix);

	return 0;
}
