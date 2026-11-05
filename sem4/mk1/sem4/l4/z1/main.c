#include <bits/time.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define max(x, y) (x < y ? y : x)

#include "init.h"

/* uint64_t x = 0, w = 0, s = 0xb5ad4eceda1ce2a9; */
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

typedef struct TNode {
    int key;
    struct TNode *left, *right;
} TNode;


TNode* insert(TNode *root, int k)
{
    TNode *ptr = root,
        *node = (TNode *) malloc(sizeof(TNode)),
        *prev = root;

    node->key = k;

    if (ptr == NULL)
        return node;

    while (ptr != NULL) {
        prev = ptr;
        if (ptr->key < k)
            ptr = ptr->right;
        else
            ptr = ptr->left;
    }

    if (prev->key < k)
        prev->right = node;
    else
        prev->left = node;

    return root;
}


TNode* delete(TNode* root, int key)
{
    TNode* curr = root;
    TNode* parent = NULL;

    while (curr != NULL && curr->key != key) {
        parent = curr;
        if (key < curr->key) {
            curr = curr->left;
        } else {
            curr = curr->right;
        }
    }

    if (curr == NULL) {
        return root;
    }

    if (curr->left != NULL && curr->right != NULL) {
        TNode* succ_parent = curr;
        TNode* succ = curr->right;

        while (succ->left != NULL) {
            succ_parent = succ;
            succ = succ->left;
        }

        curr->key = succ->key;

        parent = succ_parent;
        curr = succ;
    }

    TNode* child = (curr->left != NULL) ? curr->left : curr->right;

    if (parent == NULL) {
        root = child;
    }
    else if (curr == parent->left) {
        parent->left = child;
    }
    else {
        parent->right = child;
    }

    free(curr);

    return root;
}


void printTree(TNode* root, char* indent, int is_right)
{
    if (root == NULL) {
        return;
    }

    char next_indent[1000];
    strcpy(next_indent, indent);

    if (root->right) {
        if (is_right == 1) {
            strcat(next_indent, "    ");
        } else if (is_right == 0) {
            strcat(next_indent, "│   ");
        } else {
            strcat(next_indent, "");
        }
        printTree(root->right, next_indent, 1);
    }

    printf("%s", indent);
    if (is_right == 1) {
        printf("┌── ");
    } else if (is_right == 0) {
        printf("└── ");
    }
    printf("[%d]\n", root->key);

    if (root->left) {
        strcpy(next_indent, indent);
        if (is_right == 1) {
            strcat(next_indent, "│   ");
        } else if (is_right == 0) {
            strcat(next_indent, "    ");
        } else {
            strcat(next_indent, "");
        }
        printTree(root->left, next_indent, 0);
    }
}


void generuj_permutacje(int *tab, int n, int asc)
{
    for (int i = 0; i < n; i++) {
        tab[i] = i + 1;
    }

    if (asc)
        return;

    for (int i = n - 1; i > 0; i--) {
        int j = my_rand() % (i + 1);

        int temp = tab[i];
        tab[i] = tab[j];
        tab[j] = temp;
    }
}


int height(TNode* root) {
    if (root == NULL) {
        return -1;
    }

    return 1 + max(height(root->left), height(root->right));
}


int main(int argc, char **argv)
{
    init_rand();

    TNode *root = NULL;
    int n = 30;
    int asc = 0;
    if (argc != 2) {
        n = atoi(argv[1]);
        if (!strcmp(argv[2], "1"))
            asc = 1;
    }
    int *keys = (int *) malloc(sizeof(int) * n);
    generuj_permutacje(keys, n, asc);

    for (int i = 0; i < n; i++) {
        root = insert(root, keys[i]);
        if (n < 100) {
            printf("insert %d\n", keys[i]);
            printTree(root, "", -1);
        }
    }


    generuj_permutacje(keys, n, 0);
    for (int i = 0; i < n; i++) {
        root = delete(root, keys[i]);
        if (n < 100) {
            printf("delete %d\n", keys[i]);
            printTree(root, "", -1);
        }
    }

    return 0;
}
