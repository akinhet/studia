#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

#include "../graph.h"

void topoorder(Graph *g)
{
	int *list = calloc(g->vertices, sizeof(int)),
		*indeg = calloc(g->vertices, sizeof(int)),
		*order = calloc(g->vertices, sizeof(int));
	int listidx = 0,
		next = 0;

	memset(indeg, 0, g->vertices * sizeof(int));

	for (size_t i = 1; i <= g->vertices; i++) {
		Node *ptr = g->adj[i];
		while (ptr != NULL) {
			indeg[ptr->vertex - 1]++;
			ptr = ptr->next;
		}
	}

	for (size_t i = 1; i <= g->vertices; i++) {
		if (indeg[i - 1] == 0)
			list[listidx++] = i;
	}

	while (listidx != 0) {
		int i = list[--listidx];
		order[next++] = i;

		Node *ptr = g->adj[i];
		while (ptr != NULL) {
			indeg[ptr->vertex - 1]--;
			if (indeg[ptr->vertex - 1] == 0)
				list[listidx++] = ptr->vertex;
			ptr = ptr->next;
		}
	}

	if (next == g->vertices) {
		printf("Graph is acyclic.\n");
		if (g->vertices <= 200) {
			for (size_t i = 0; i < g->vertices; i++) {
				printf("%d ", order[i]);
			}
			printf("\n");
		}
	} else {
		printf("Graph has a directed cycle.\n");
	}

	free(list);
	free(indeg);
	free(order);
}


int main(int argc, char **argv)
{
	FILE *input = stdin;

	if (argc > 1) {
		input = fopen(argv[1], "r");

		if (!input) {
			perror("fopen");
			return 1;
		}
	}

	Graph *g = graph_read(input);

	if (input != stdin)
		fclose(input);

	if (!g) {
		fprintf(stderr, "Failed to read graph\n");
		return 1;
	}

	topoorder(g);
	printf("\n");

	graph_free(g);
	return 0;
}
