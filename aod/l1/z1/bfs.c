#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#include "../graph.h"

void bfs(Graph *g)
{
	int n = g->vertices;
	bool *visited = calloc(n + 1, sizeof(bool));
	int *parent = calloc(n + 1, sizeof(int));
	int *order = malloc((n + 1) * sizeof(int));
	int *queue = malloc((n + 1) * sizeof(int));

	if (!visited || !parent || !order || !queue) {
		free(visited);
		free(parent);
		free(order);
		free(queue);
		return;
	}

	int count = 0;

	for (int start = 1; start <= n; start++) {
		if (visited[start])
			continue;

		int head = 0, tail = 0;

		visited[start] = true;
		queue[tail++] = start;

		while (head < tail) {
			int u = queue[head++];
			order[count++] = u;

			for (Node *p = g->adj[u]; p; p = p->next) {
				int v = p->vertex;

				if (!visited[v]) {
					visited[v] = true;
					parent[v] = u;
					queue[tail++] = v;
				}
			}
		}
	}

	printf("BFS order: ");
	for (int i = 0; i < count; i++)
		printf("%d ", order[i]);

	printf("\nBFS tree:\n");
	for (int i = 0; i < count; i++) {
		int v = order[i];
		if (parent[v] != 0)
			printf("%d %d\n", parent[v], v);
	}

	free(visited);
	free(parent);
	free(order);
	free(queue);
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

	bfs(g);
	printf("\n");

	graph_free(g);
	return 0;
}
