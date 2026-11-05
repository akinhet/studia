#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>


int main (int argc, char **argv)
{
	if (argc != 2)
		return 1;
	FILE *f = fopen(argv[1], "r");

	uint64_t I[256],
	         Ivar[256][256];

	memset(I, 0, 256 * sizeof(uint64_t));
	for (int i = 0; i < 256; i++)
		memset(Ivar[i], 0, 256 * sizeof(uint64_t));

	int prev = 0,
		 curr = 0;
	uint64_t count = 0;

	while ((curr = fgetc(f)) != EOF) {
		I[curr]++;
		Ivar[prev][curr]++;
		count++;

		prev = curr;
	}

	fclose(f);

	double ent = 0,
		   entvar = 0;

	for (int i = 0; i < 256; i++) {
		if (!I[i])
			continue;

		ent -= ((double) I[i]) * log2(I[i]);
		entvar += ((double) I[i]) * log2(I[i]);

		double tempvar = 0;
		for (int j = 0; j < 256; j++) {
			if (!Ivar[i][j])
				continue;
			tempvar += ((double) Ivar[i][j]) * log2(Ivar[i][j]);
		}

		entvar -= tempvar;
	}

	ent /= (double) count;
	ent += log2(count);

	entvar /= (double) count;

	printf("%s:\nn = %d\nH(X) = %f bits\nH(X|Y) = %f bits\nH(X) - H(X|Y) = %f bits\n", argv[1], (int) count, ent, entvar, ent - entvar);

	return 0;
}
