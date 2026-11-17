#pragma once

#include <stdbool.h>
#include <stddef.h>

#define sibling(i) ((i & 1) ? i + 1 : i - 1)

typedef struct {
	bool isleaf,
		 isNYT;
	unsigned char symbol;
	size_t weight,
		   parent,
		   child;
} Node;

typedef struct {
	Node nodes[513];
	size_t symbols[256];

	size_t count,
		   NYT;
} Tree;


void pushc(Tree *t, unsigned char c)
{
	int newNYT = t->count + 1;
	t->count += 2;
	t->nodes[t->NYT].child = newNYT - 1;
	t->nodes[t->NYT].isleaf = false;
	t->nodes[t->NYT].isNYT = false;

	t->nodes[newNYT].parent = t->NYT;
	t->nodes[newNYT].isleaf = true;
	t->nodes[newNYT].isNYT = true;
	t->nodes[newNYT].weight = 0;

	t->nodes[newNYT-1].parent = t->NYT;
	t->nodes[newNYT-1].isleaf = true;
	t->nodes[newNYT-1].isNYT = false;
	t->nodes[newNYT-1].weight = 1;

	t->NYT = newNYT;

	t->symbols[c] = newNYT - 1;
}


void swap_nodes(Tree *t, size_t i, size_t j) {}


void fixtree(Tree *t, size_t idx)
{
	int curr = idx;
	while (curr > 0) {
		int w = t->nodes[curr].weight;
		int i = 0;
		for (i = 0; i < curr; i++) {
			if (t->nodes[i].weight == w)
				break;
		}

		swap_nodes(t, curr, i);
		curr = i;
		t->nodes[curr].weight++;
		curr = t->nodes[curr].parent;
	}
}
