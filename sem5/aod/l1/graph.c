#include <stdlib.h>

#include "graph.h"

Graph *graph_create(int vertices, bool directed)
{
    Graph *g = malloc(sizeof(Graph));
    if (!g) return NULL;

    g->vertices = vertices;
    g->directed = directed;
    g->adj = calloc(vertices + 1, sizeof(Node *));

    if (!g->adj) {
        free(g);
        return NULL;
    }

    return g;
}


void add_neighbor(Graph *g, int u, int v)
{
    Node *node = malloc(sizeof(Node));
    if (!node) {
        perror("malloc");
        exit(EXIT_FAILURE);
    }

    node->vertex = v;
    node->next = g->adj[u];
    g->adj[u] = node;
}


void graph_add_edge(Graph *g, int u, int v)
{
    if (!g || u < 1 || v < 1 ||
        u > g->vertices || v > g->vertices)
        return;

    add_neighbor(g, u, v);

    if (!g->directed && u != v)
        add_neighbor(g, v, u);
}


void graph_free(Graph *g)
{
    if (!g) return;

    for (int i = 1; i <= g->vertices; i++) {
        Node *p = g->adj[i];

        while (p) {
            Node *next = p->next;
            free(p);
            p = next;
        }
    }

    free(g->adj);
    free(g);
}


Graph *graph_read(FILE *input)
{
    char type;
    int n, m;

    if (fscanf(input, " %c", &type) != 1)
        return NULL;

    if (type != 'D' && type != 'U')
        return NULL;

    if (fscanf(input, "%d %d", &n, &m) != 2)
        return NULL;

    if (n < 0 || m < 0)
        return NULL;

    Graph *g = graph_create(n, type == 'D');
    if (!g)
        return NULL;

    for (int i = 0; i < m; i++) {
        int u, v;

        if (fscanf(input, "%d %d", &u, &v) != 2 || u < 1 || v < 1 || u > n || v > n) {
            fprintf(stderr, "Invalid edge\n");
            graph_free(g);
            return NULL;
        }

        graph_add_edge(g, u, v);
    }

    return g;
}
