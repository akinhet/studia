#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#include "../graph.h"


void dfs_visit(Graph *g, int u, bool *visited, int *parent, int *order, int *count)
{
	visited[u] = true;
	order[(*count)++] = u;

	for (Node *p = g->adj[u]; p; p = p->next) {
		int v = p->vertex;

		if (!visited[v]) {
			parent[v] = u;
			dfs_visit(g, v, visited, parent, order, count);
		}
	}
}


void dfs(Graph *g)
{
	int n = g->vertices;
	bool *visited = calloc(n + 1, sizeof(bool));
	int *parent = calloc(n + 1, sizeof(int));
	int *order = malloc((n + 1) * sizeof(int));

	if (!visited || !parent || !order) {
		free(visited);
		free(parent);
		free(order);
		return;
	}

	int count = 0;

	for (int i = 1; i <= n; i++) {
		if (!visited[i])
			dfs_visit(g, i, visited, parent, order, &count);
	}

	printf("DFS order: ");
	for (int i = 0; i < count; i++)
		printf("%d ", order[i]);

	printf("\nDFS tree:\n");
	for (int i = 0; i < count; i++) {
		int v = order[i];
		if (parent[v] != 0)
			printf("%d %d\n", parent[v], v);
	}

	free(visited);
	free(parent);
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

	dfs(g);
	printf("\n");

	graph_free(g);
	return 0;
}
