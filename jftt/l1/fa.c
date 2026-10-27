#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int **computedelta(char *P)
{
	size_t m = strlen(P);
	int **delta = calloc(m + 1, sizeof(int*));
	for (size_t i = 0; i <= m; i++) {
		delta[i] = calloc(256, sizeof(int));
	}

	for (size_t q = 0; q <= m; q++) {
		for (size_t a = 0; a < 256; a++) {
			int k = m < q + 1 ? m : q + 1;
			while (k > 0 && ( (unsigned char) P[k - 1] != a || memcmp(P, P + q - k + 1, k - 1) != 0)) {
				k--;
			}

			delta[q][a] = k;
		}
	}

	return delta;
}


void famatcher(FILE *f, int **delta, int m)
{
	int q = 0;
	size_t line = 1,
		   cnt = 0;
	
	int a = 0;
	while ((a = fgetc(f)) != EOF) {
		if (a == '\n')
			line++;
		cnt++;
		q = delta[q][a];
		if (q == m)
			printf("char %zu line %zu\n", cnt - m, line);
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

	int **delta = computedelta(argv[1]);

	famatcher(f, delta, strlen(argv[1]));

	int m = strlen(argv[1]);
	for (int i = 0; i <= m; i++)
		free(delta[i]);

	free(delta);
	fclose(f);
	return 0;
}
