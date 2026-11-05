#include <stdbool.h>
#include <stdlib.h>


inline int power(int a, int b)
{
	int ret = 1;
	for (int i = 0; i < b; i++) {
		ret *= a;
	}

	return ret;
}


int** gen_permutations(int digits, int setsize)
{
	bool overflow = false;
	int length = power(digits, setsize);
	int **ret_array = (int**) malloc(length * sizeof(int*));

	for (int i = 0; i < length; i++) {

	}
}
