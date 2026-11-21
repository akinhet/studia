#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#include "htree.h"


typedef struct {
	FILE *in;
	unsigned char byte;
	unsigned bits;
} BitReader;


static int read_bit(BitReader *b)
{
	if (b->bits == 0) {
		int c = fgetc(b->in);
		if (c == EOF)
			return -1;

		b->byte = (unsigned char)c;
		b->bits = 8;
	}

	int bit = (b->byte >> 7) & 1;
	b->byte <<= 1;
	b->bits--;

	return bit;
}


static int read_byte(BitReader *b)
{
	int c = 0;

	for (int i = 0; i < 8; i++) {
		int bit = read_bit(b);
		if (bit < 0)
			return -1;

		c = (c << 1) | bit;
	}

	return c;
}


static int read_u64(FILE *in, uint64_t *value)
{
	*value = 0;

	for (int i = 0; i < 8; i++) {
		int c = fgetc(in);
		if (c == EOF)
			return -1;

		*value = (*value << 8) | (unsigned char)c;
	}

	return 0;
}


int main(int argc, char *argv[])
{
	if (argc != 2) {
		fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
		return EXIT_FAILURE;
	}

	FILE *in = fopen(argv[1], "rb");
	if (in == NULL) {
		fprintf(stderr, "ERROR: cannot open file %s\n", argv[1]);
		return EXIT_FAILURE;
	}

	uint64_t total;
	if (read_u64(in, &total) < 0) {
		fprintf(stderr, "ERROR: invalid file header\n");
		fclose(in);
		return EXIT_FAILURE;
	}

	FILE *out = fopen("out.dec", "wb");
	if (out == NULL) {
		fprintf(stderr, "ERROR: cannot create file out.dec\n");
		fclose(in);
		return EXIT_FAILURE;
	}

	Tree t = {0};
	t.count = 1;
	t.NYT = 0;
	t.nodes[0].isleaf = true;
	t.nodes[0].isNYT = true;
	t.nodes[0].weight = 0;
	t.nodes[0].parent = NIL;
	t.nodes[0].child = NIL;

	BitReader bits = {.in = in};

	for (uint64_t n = 0; n < total; n++) {
		size_t idx = 0;

		while (!t.nodes[idx].isleaf) {
			int bit = read_bit(&bits);
			if (bit < 0)
				goto error;

			idx = t.nodes[idx].child + (size_t)bit;
			if (idx >= t.count)
				goto error;
		}

		unsigned char c;

		if (t.nodes[idx].isNYT) {
			int raw = read_byte(&bits);
			if (raw < 0 || t.symbols[raw] != 0)
				goto error;

			c = (unsigned char)raw;
			size_t parent = t.nodes[t.NYT].parent;

			pushc(&t, c);

			if (parent != NIL)
				fixtree(&t, parent);
		} else {
			c = t.nodes[idx].symbol;
			fixtree(&t, idx);
		}

		if (fputc(c, out) == EOF)
			goto error;
	}

	if (fclose(out) != 0) {
		fclose(in);
		return EXIT_FAILURE;
	}

	fclose(in);
	return EXIT_SUCCESS;

error:
	fprintf(stderr, "ERROR: damaged or truncated compressed file, or write error\n");
	fclose(in);
	fclose(out);
	return EXIT_FAILURE;
}
