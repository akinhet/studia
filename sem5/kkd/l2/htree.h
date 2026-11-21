#pragma once

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#define sibling(i) (((i) & 1) ? (i) + 1 : (i) - 1)
#define NIL ((size_t)-1)

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


static void pushc(Tree *t, unsigned char c)
{
	size_t newNYT = t->count + 1;
	size_t oldNYT = t->NYT;

	t->count += 2;

	t->nodes[oldNYT].child = newNYT - 1;
	t->nodes[oldNYT].isleaf = false;
	t->nodes[oldNYT].isNYT = false;
	t->nodes[oldNYT].weight = 1;

	t->nodes[newNYT].parent = oldNYT;
	t->nodes[newNYT].isleaf = true;
	t->nodes[newNYT].isNYT = true;
	t->nodes[newNYT].weight = 0;
	t->nodes[newNYT].child = NIL;

	t->nodes[newNYT - 1].parent = oldNYT;
	t->nodes[newNYT - 1].isleaf = true;
	t->nodes[newNYT - 1].isNYT = false;
	t->nodes[newNYT - 1].weight = 1;
	t->nodes[newNYT - 1].child = NIL;
	t->nodes[newNYT - 1].symbol = c;

	t->NYT = newNYT;
	t->symbols[c] = newNYT - 1;
}


static void swap_nodes(Tree *t, size_t i, size_t j)
{
	if (i == j)
		return;

	size_t pi = t->nodes[i].parent;
	size_t pj = t->nodes[j].parent;

	Node tmp = t->nodes[i];
	t->nodes[i] = t->nodes[j];
	t->nodes[j] = tmp;

	t->nodes[i].parent = pi;
	t->nodes[j].parent = pj;

	for (size_t k = 0; k < 2; k++) {
		size_t at = (k == 0) ? i : j;
		Node *n = &t->nodes[at];

		if (!n->isleaf) {
			t->nodes[n->child].parent = at;
			t->nodes[n->child + 1].parent = at;
		} else if (n->isNYT) {
			t->NYT = at;
		} else {
			t->symbols[n->symbol] = at;
		}
	}
}


static void fixtree(Tree *t, size_t idx)
{
	size_t curr = idx;

	while (curr != NIL) {
		size_t w = t->nodes[curr].weight;
		size_t i = 0;

		for (; i < curr; i++) {
			if (t->nodes[i].weight == w)
				break;
		}

		if (i != curr && i != t->nodes[curr].parent) {
			swap_nodes(t, curr, i);
			curr = i;
		}

		t->nodes[curr].weight++;
		curr = t->nodes[curr].parent;
	}
}
