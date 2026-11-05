#include <stdlib.h>
#include <stdio.h>

#include "../graph.h"


bool is_bipartite(Graph *g)
{
	int n = g->vertices;

	Graph *undirected = graph_create(n, false);
	if (!undirected)
		return false;

	for (int u = 1; u <= n; u++) {
		for (Node *p = g->adj[u]; p; p = p->next)
			graph_add_edge(undirected, u, p->vertex);
	}

	int *color = malloc((n + 1) * sizeof(int));
	int *queue = malloc((n + 1) * sizeof(int));

	if (!color || !queue) {
		free(color);
		free(queue);
		graph_free(undirected);
		return false;
	}

	for (int i = 1; i <= n; i++)
		color[i] = -1;

	bool bipartite = true;

	for (int start = 1; start <= n && bipartite; start++) {
		if (color[start] != -1)
			continue;

		int head = 0, tail = 0;
		color[start] = 0;
		queue[tail++] = start;

		while (head < tail && bipartite) {
			int u = queue[head++];

			for (Node *p = undirected->adj[u]; p; p = p->next) {
				int v = p->vertex;

				if (color[v] == -1) {
					color[v] = 1 - color[u];
					queue[tail++] = v;
				} else if (color[v] == color[u]) {
					bipartite = false;
					break;
				}
			}
		}
	}

	if (bipartite && n <= 200) {
		printf("V0: ");
		for (int i = 1; i <= n; i++) {
			if (color[i] == 0)
				printf("%d ", i);
		}

		printf("\nV1: ");
		for (int i = 1; i <= n; i++) {
			if (color[i] == 1)
				printf("%d ", i);
		}

		printf("\n");
	}

	free(color);
	free(queue);
	graph_free(undirected);

	return bipartite;
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

	if (is_bipartite(g))
		printf("Graph is bipartite.\n");
	else
		printf("Graph is not bipartite.\n");

	graph_free(g);
	return 0;
}
