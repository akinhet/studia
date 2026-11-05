#include <stdio.h>
#include <stdbool.h>

typedef struct Node {
    int vertex;
    struct Node *next;
} Node;

typedef struct {
    int vertices;
    bool directed;
    Node **adj;
} Graph;


Graph *graph_create(int vertices, bool directed);
void add_neighbor(Graph *g, int u, int v);
void graph_add_edge(Graph *g, int u, int v);
void graph_free(Graph *g);
Graph *graph_read(FILE *input);
