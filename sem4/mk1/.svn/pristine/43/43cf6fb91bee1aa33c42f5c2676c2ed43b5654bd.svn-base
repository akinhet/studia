#include <stdint.h>
#include <stdio.h>
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

typedef struct {
    int u, v;
    double weight;
} Edge;

typedef struct {
    int parent;
    int rank;
} Subset;

int find_set(Subset subsets[], int i) {
    if (subsets[i].parent != i)
        subsets[i].parent = find_set(subsets, subsets[i].parent);
    return subsets[i].parent;
}

void union_sets(Subset subsets[], int x, int y) {
    int xroot = find_set(subsets, x);
    int yroot = find_set(subsets, y);

    if (subsets[xroot].rank < subsets[yroot].rank)
        subsets[xroot].parent = yroot;
    else if (subsets[xroot].rank > subsets[yroot].rank)
        subsets[yroot].parent = xroot;
    else {
        subsets[yroot].parent = xroot;
        subsets[xroot].rank++;
    }
}

int compare_edges(const void* a, const void* b) {
    double wA = ((Edge*)a)->weight;
    double wB = ((Edge*)b)->weight;
    if (wA < wB) return -1;
    if (wA > wB) return 1;
    return 0;
}

double algorytm_prima(double **matrix, int n) {
    double *min_weight = (double *)malloc(n * sizeof(double));
    int *visited = (int *)calloc(n, sizeof(int));
    double mst_weight = 0.0;

    for (int i = 0; i < n; i++) {
        min_weight[i] = 2.0;
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
        mst_weight += min_val;

        for (int v = 0; v < n; v++) {
            if (!visited[v] && matrix[u][v] < min_weight[v] && u != v) {
                min_weight[v] = matrix[u][v];
            }
        }
    }

    free(min_weight);
    free(visited);
    return mst_weight;
}

double algorytm_kruskala(double **matrix, int n) {
    int num_edges = n * (n - 1) / 2;
    Edge *edges = (Edge *)malloc(num_edges * sizeof(Edge));
    int idx = 0;

    for (int i = 0; i < n; i++) {
        for (int j = i + 1; j < n; j++) {
            edges[idx].u = i;
            edges[idx].v = j;
            edges[idx].weight = matrix[i][j];
            idx++;
        }
    }

    qsort(edges, num_edges, sizeof(Edge), compare_edges);

    Subset *subsets = (Subset *)malloc(n * sizeof(Subset));
    for (int i = 0; i < n; i++) {
        subsets[i].parent = i;
        subsets[i].rank = 0;
    }

    double mst_weight = 0.0;
    int edges_count = 0;

    for (int i = 0; i < num_edges && edges_count < n - 1; i++) {
        int x = find_set(subsets, edges[i].u);
        int y = find_set(subsets, edges[i].v);

        if (x != y) {
            mst_weight += edges[i].weight;
            edges_count++;
            union_sets(subsets, x, y);
        }
    }

    free(subsets);
    free(edges);
    return mst_weight;
}

double** generuj_graf(int n) {
    double **matrix = (double **)malloc(n * sizeof(double *));
    for (int i = 0; i < n; i++) {
        matrix[i] = (double *)malloc(n * sizeof(double));
    }

    for (int i = 0; i < n; i++) {
        matrix[i][i] = 0.0;
        for (int j = i + 1; j < n; j++) {
            double waga = rand_double();
            matrix[i][j] = waga;
            matrix[j][i] = waga;
        }
    }
    return matrix;
}

void zwolnij_graf(double **matrix, int n) {
    for (int i = 0; i < n; i++) {
        free(matrix[i]);
    }
    free(matrix);
}

int main() {
    init_rand();
    int nMin = 100;
    int nMax = 5000;
    int step = 100;
    int rep = 10;

    printf("n,Prim_Time,Kruskal_Time\n");

    for (int n = nMin; n <= nMax; n += step) {
        double total_time_prim = 0.0;
        double total_time_kruskal = 0.0;

        for (int r = 0; r < rep; r++) {
            double **graf = generuj_graf(n);

            clock_t start = clock();
            algorytm_prima(graf, n);
            clock_t end = clock();
            total_time_prim += (double)(end - start) / CLOCKS_PER_SEC;

            start = clock();
            algorytm_kruskala(graf, n);
            end = clock();
            total_time_kruskal += (double)(end - start) / CLOCKS_PER_SEC;

            zwolnij_graf(graf, n);
        }

        double avg_prim = total_time_prim / rep;
        double avg_kruskal = total_time_kruskal / rep;

        printf("%d,%.6f,%.6f\n", n, avg_prim, avg_kruskal);
    }

    return 0;
}
