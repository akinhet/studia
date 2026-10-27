#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int *computepi(char *P)
{
	size_t m = strlen(P);
	int *pi = calloc(m, sizeof(int));

	pi[0] = 0;
	int k = 0;

	for (size_t q = 2; q <= m; q++) {
		while (k > 0 && P[k] != P[q])
			k = pi[k - 1];
		if (P[k] == P[q])
			k++;
		pi[q - 1] = k;
	}

	return pi;
}


void kmpmatcher(FILE *f, char *P)
{
	size_t m = strlen(P),
		   line = 1,
		   cnt = 0;
	

	int *pi = computepi(P),
		q = 0;

	int a = 0;
	while ((a = fgetc(f)) != EOF) {
		if (a == '\n')
			line++;
		cnt++;

		while (q > 0 && P[q] != a)
			q = pi[q - 1];
		if (P[q] == a)
			q++;
		if (q == m) {
			printf("char %zu line %zu\n", cnt - m, line);
			q = pi[q - 1];
		}
	}
}


int main(int argc, char *argv[])
{
	if (argc != 3)
		return 1;

	FILE *f = fopen(argv[2], "r");
	if (f == NULL) {
		perror("fopen");
		return 2;
	}

	kmpmatcher(f, argv[1]);

	fclose(f);
	return 0;
}
