#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <time.h>

#include "init.h"

uint64_t x, w, s;

static void init_rand() {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    x = w = s = init_rand_digits(ts.tv_nsec ^ ts.tv_sec);
}

inline static uint32_t my_rand() {
  x *= x;
  x += (w += s);
  return x = (x >> 32) | (x << 32);
}
double rand_double() {
    return (double)my_rand() / ((double)4294967295 + 1.0);
}

typedef struct Node {
    int vertex;
    struct Node* next;
} Node;

typedef struct Graph {
    int numVertices;
    Node** adjLists;
} Graph;

Graph* stworz_drzewo(int vertices) {
    Graph* graph = (Graph*)malloc(sizeof(Graph));
    graph->numVertices = vertices;
    graph->adjLists = (Node**)malloc(vertices * sizeof(Node*));
    for (int i = 0; i < vertices; i++) {
        graph->adjLists[i] = NULL;
    }
    return graph;
}

void dodaj_krawedz_drzewa(Graph* graph, int src, int dest) {
    Node* newNode = (Node*)malloc(sizeof(Node));
    newNode->vertex = dest;
    newNode->next = graph->adjLists[src];
    graph->adjLists[src] = newNode;

    newNode = (Node*)malloc(sizeof(Node));
    newNode->vertex = src;
    newNode->next = graph->adjLists[dest];
    graph->adjLists[dest] = newNode;
}

void zwolnij_drzewo(Graph* graph) {
    for (int i = 0; i < graph->numVertices; i++) {
        Node* temp = graph->adjLists[i];
        while (temp) {
            Node* to_free = temp;
            temp = temp->next;
            free(to_free);
        }
    }
    free(graph->adjLists);
    free(graph);
}

int porownaj_malejaco(const void* a, const void* b) {
    return (*(int*)b - *(int*)a);
}

int oblicz_rundy(int u, int p, Graph* tree) {
    int child_count = 0;
    Node* temp = tree->adjLists[u];
    while (temp != NULL) {
        if (temp->vertex != p) {
            child_count++;
        }
        temp = temp->next;
    }

    if (child_count == 0) return 0;

    int* child_rounds = (int*)malloc(child_count * sizeof(int));
    int idx = 0;
    temp = tree->adjLists[u];
    while (temp != NULL) {
        if (temp->vertex != p) {
            child_rounds[idx++] = oblicz_rundy(temp->vertex, u, tree);
        }
        temp = temp->next;
    }

    qsort(child_rounds, child_count, sizeof(int), porownaj_malejaco);

    int max_rounds = 0;
    for (int i = 0; i < child_count; i++) {
        int current_rounds = (i + 1) + child_rounds[i];
        if (current_rounds > max_rounds) {
            max_rounds = current_rounds;
        }
    }

    free(child_rounds);
    return max_rounds;
}

Graph* algorytm_prima_drzewo(double **matrix, int n) {
    double *min_weight = (double *)malloc(n * sizeof(double));
    int *visited = (int *)calloc(n, sizeof(int));
    int *parent = (int *)malloc(n * sizeof(int));

    for (int i = 0; i < n; i++) {
        min_weight[i] = 2.0;
        parent[i] = -1;
    }
    min_weight[0] = 0.0;

    for (int count = 0; count < n; count++) {
        int u = -1;
        double min_val = 2.0;

        for (int i = 0; i < n; i++) {
            if (!visited[i] && min_weight[i] < min_val) {
                min_val = min_weight[i];
                u = i;
            }
        }

        if (u == -1) break;
        visited[u] = 1;

        for (int v = 0; v < n; v++) {
            if (!visited[v] && matrix[u][v] < min_weight[v] && u != v) {
                min_weight[v] = matrix[u][v];
                parent[v] = u;
            }
        }
    }

    Graph* tree = stworz_drzewo(n);
    for (int i = 1; i < n; i++) {
        if (parent[i] != -1) {
            dodaj_krawedz_drzewa(tree, parent[i], i);
        }
    }

    free(min_weight);
    free(visited);
    free(parent);
    return tree;
}

double** generuj_graf(int n) {
    double **matrix = (double **)malloc(n * sizeof(double *));
    for (int i = 0; i < n; i++) matrix[i] = (double *)malloc(n * sizeof(double));
    for (int i = 0; i < n; i++) {
        matrix[i][i] = 0.0;
        for (int j = i + 1; j < n; j++) {
            double waga = rand_double();
            matrix[i][j] = waga; matrix[j][i] = waga;
        }
    }
    return matrix;
}

void zwolnij_graf(double **matrix, int n) {
    for (int i = 0; i < n; i++) free(matrix[i]);
    free(matrix);
}

int main() {
    init_rand();
    int nMin = 100;
    int nMax = 5000;
    int step = 100;
    int rep = 30;

    printf("n,Min_Rounds,Max_Rounds,Avg_Rounds\n");

    for (int n = nMin; n <= nMax; n += step) {
        int min_r = 999999;
        int max_r = 0;
        long long sum_r = 0;

        for (int r = 0; r < rep; r++) {
            double **graf = generuj_graf(n);
            Graph* mst_tree = algorytm_prima_drzewo(graf, n);

            int korzen = rand() % n;

            int rundy = oblicz_rundy(korzen, -1, mst_tree);

            if (rundy < min_r) min_r = rundy;
            if (rundy > max_r) max_r = rundy;
            sum_r += rundy;

            zwolnij_drzewo(mst_tree);
            zwolnij_graf(graf, n);
        }

        double avg_r = (double)sum_r / rep;
        printf("%d,%d,%d,%.2f\n", n, min_r, max_r, avg_r);
    }

    return 0;
}
