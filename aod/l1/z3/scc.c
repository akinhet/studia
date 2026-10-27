#include <stdlib.h>
#include <string.h>

#include "../graph.h"


void scc_dfs1(Graph *g, int u, bool *visited, int *order, int *count)
{
	visited[u] = true;

	for (Node *p = g->adj[u]; p; p = p->next) {
		int v = p->vertex;

		if (!visited[v])
			scc_dfs1(g, v, visited, order, count);
	}

	order[(*count)++] = u;
}


Graph *graph_transpose(Graph *g)
{
	Graph *t = graph_create(g->vertices, true);
	if (!t)
		return NULL;

	for (int u = 1; u <= g->vertices; u++) {
		for (Node *p = g->adj[u]; p; p = p->next) {
			graph_add_edge(t, p->vertex, u);
		}
	}

	return t;
}


void scc_dfs2(Graph *g, int u, bool *visited,
			  int *component, int *size)
{
	visited[u] = true;
	component[(*size)++] = u;

	for (Node *p = g->adj[u]; p; p = p->next) {
		int v = p->vertex;

		if (!visited[v])
			scc_dfs2(g, v, visited, component, size);
	}
}

void strongly_connected_components(Graph *g)
{
	if (!g->directed) {
		printf("Graph must be directed.\n");
		return;
	}

	int n = g->vertices;

	bool *visited = calloc(n + 1, sizeof(bool));
	int *order = malloc((n + 1) * sizeof(int));
	int *component = malloc((n + 1) * sizeof(int));
	int *sizes = calloc(n + 1, sizeof(int));

	if (!visited || !order || !component || !sizes) {
		free(visited);
		free(order);
		free(component);
		free(sizes);
		return;
	}

	int count = 0;

	for (int u = 1; u <= n; u++) {
		if (!visited[u])
			scc_dfs1(g, u, visited, order, &count);
	}

	Graph *t = graph_transpose(g);

	if (!t) {
		free(visited);
		free(order);
		free(component);
		free(sizes);
		return;
	}

	memset(visited, 0, (n + 1) * sizeof(bool));

	int components = 0;

	for (int i = count - 1; i >= 0; i--) {
		int u = order[i];

		if (!visited[u]) {
			int size = 0;

			scc_dfs2(t, u, visited, component, &size);

			sizes[components++] = size;

			if (n <= 200) {
				printf("SCC %d: ", components);

				for (int j = 0; j < size; j++)
					printf("%d ", component[j]);

				printf("\n");
			}
		}
	}

	printf("Number of SCCs: %d\n", components);

	for (int i = 0; i < components; i++)
		printf("SCC %d size: %d\n", i + 1, sizes[i]);

	graph_free(t);
	free(visited);
	free(order);
	free(component);
	free(sizes);
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

	strongly_connected_components(g);
	printf("\n");

	graph_free(g);
	return 0;
}
