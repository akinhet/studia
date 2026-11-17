#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

#include "htree.h"


int main(int argc, char *argv[])
{
	if (argc != 2) {
		printf("Usage: %s <filename>\n", argv[0]);
		return EXIT_FAILURE;
	}

	FILE *in = fopen(argv[1], "r");
	if (in == NULL) {
		printf("ERROR: cannot open file %s\n\nUsage: %s <filename>\n", argv[1], argv[0]);
		return EXIT_FAILURE;
	}

	FILE *out = fopen("out.comp", "w");
	if (out == NULL) {
		printf("ERROR: cannot create file out.comp\n");
		return EXIT_FAILURE;
	}

	Tree t;
	memset(t.symbols, 0, sizeof(size_t) * 256);
	t.count = 1;
	t.NYT = 0;
	t.nodes[0].isleaf = true;
	t.nodes[0].isNYT = true;
	t.nodes[0].weight = 0;
	t.nodes[0].parent = -1;
	t.nodes[0].child = -1;

	int c = 0;
	while((c = fgetc(in)) != EOF) {
		if(t.symbols[c] == 0) {
			pushc(&t, c);
		} else {
			t.nodes[t.symbols[c]].weight++;
		}

		fixtree(&t, t.symbols[c]);
	}

	return EXIT_SUCCESS;
}

