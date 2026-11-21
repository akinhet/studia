#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <stdint.h>
#include <math.h>

#include "htree.h"


typedef struct {
	FILE *out;
	unsigned char byte;
	unsigned bits;
	uint64_t total_bits;
} BitWriter;


static int write_bit(BitWriter *b, unsigned bit)
{
	b->byte = (unsigned char)((b->byte << 1) | (bit & 1));
	b->total_bits++;

	if (++b->bits == 8) {
		if (fputc(b->byte, b->out) == EOF)
			return -1;

		b->byte = 0;
		b->bits = 0;
	}

	return 0;
}


static int write_byte(BitWriter *b, unsigned char c)
{
	for (int i = 7; i >= 0; i--) {
		if (write_bit(b, (c >> i) & 1) < 0)
			return -1;
	}

	return 0;
}


static int write_code(BitWriter *b, const Tree *t, size_t node)
{
	unsigned char bits[513];
	size_t count = 0;

	while (node != 0) {
		bits[count++] = (node & 1) == 0;
		node = t->nodes[node].parent;
	}

	while (count) {
		if (write_bit(b, bits[--count]) < 0)
			return -1;
	}

	return 0;
}


static int flush_bits(BitWriter *b)
{
	if (b->bits) {
		if (fputc(b->byte << (8 - b->bits), b->out) == EOF)
			return -1;

		b->bits = 0;
	}

	return 0;
}


static int write_u64(FILE *f, uint64_t x)
{
	for (int i = 7; i >= 0; i--) {
		if (fputc((int)((x >> (i * 8)) & 0xff), f) == EOF)
			return -1;
	}

	return 0;
}


int main(int argc, char *argv[])
{
	if (argc != 2) {
		printf("Usage: %s <filename>\n", argv[0]);
		return EXIT_FAILURE;
	}

	FILE *in = fopen(argv[1], "rb");
	if (in == NULL) {
		printf("ERROR: cannot open file %s\n", argv[1]);
		return EXIT_FAILURE;
	}

	FILE *out = fopen("out.comp", "wb");
	if (out == NULL) {
		printf("ERROR: cannot create file out.comp\n");
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

	BitWriter bits = {.out = out};
	uint64_t frequencies[256] = {0};

	if (write_u64(out, 0) < 0)
		goto error;

	uint64_t total = 0;

	int c = 0;
	while ((c = fgetc(in)) != EOF) {
		frequencies[c]++;
		if (t.symbols[c] == 0) {
			if (write_code(&bits, &t, t.NYT) < 0 ||
				write_byte(&bits, (unsigned char)c) < 0)
				goto error;

			size_t parent = t.nodes[t.NYT].parent;

			pushc(&t, (unsigned char)c);

			if (parent != NIL)
				fixtree(&t, parent);

		} else {
			if (write_code(&bits, &t, t.symbols[c]) < 0)
				goto error;

			fixtree(&t, t.symbols[c]);
		}

		total++;
	}

	if (ferror(in) || flush_bits(&bits) < 0)
		goto error;

	if (fseek(out, 0, SEEK_SET) != 0 ||
		write_u64(out, total) < 0)
		goto error;

	if (fclose(out) != 0) {
		fclose(in);
		return EXIT_FAILURE;
	}

	fclose(in);

	double entropy = 0.0;
	double avg_length = 0.0;
	double compression = 0.0;

	uint64_t compressed_size = 8 + bits.total_bits / 8 + (bits.total_bits % 8 != 0);

	if (total > 0) {
		for (size_t i = 0; i < 256; i++) {
			if (frequencies[i] == 0)
				continue;

			double p = (double)frequencies[i] / (double)total;
			entropy -= p * log2(p);
		}

		avg_length = (double)bits.total_bits / (double)total;
		compression = 100.0 * (1.0 - (double)compressed_size / (double)total);
	}

	printf("Input size:         %llu bytes\n", (unsigned long long)total);
	printf("Compressed size:    %llu bytes\n", (unsigned long long)compressed_size);
	printf("Entropy:            %.6f bits/symbol\n", entropy);
	printf("Average code length: %.6f bits/symbol\n", avg_length);
	printf("Compression:        %.2f%%\n", compression);

	return EXIT_SUCCESS;

error:
	fprintf(stderr, "ERROR: encoding failed\n");
	fclose(in);
	fclose(out);
	return EXIT_FAILURE;
}
