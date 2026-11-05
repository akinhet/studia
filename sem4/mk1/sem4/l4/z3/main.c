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

TNode* newNode(int key) {
    TNode* node = (TNode*)malloc(sizeof(TNode));
    node->key = key;
    node->left = node->right = NULL;
    return node;
}

TNode* rightRotate(TNode* x) {
    TNode* y = x->left;
    x->left = y->right;
    y->right = x;
    return y;
}

TNode* leftRotate(TNode* x) {
    TNode* y = x->right;
    x->right = y->left;
    y->left = x;
    return y;
}

TNode* splay(TNode* root, int key) {
    if (root == NULL || root->key == key)
        return root;

    if (root->key > key) {
        if (root->left == NULL) return root;

        if (root->left->key > key) {
            root->left->left = splay(root->left->left, key);
            root = rightRotate(root);
        }
        else if (root->left->key < key) {
            root->left->right = splay(root->left->right, key);
            if (root->left->right != NULL)
                root->left = leftRotate(root->left);
        }

        return (root->left == NULL) ? root : rightRotate(root);
    }
    else {
        if (root->right == NULL) return root;

        if (root->right->key > key) {
            root->right->left = splay(root->right->left, key);
            if (root->right->left != NULL)
                root->right = rightRotate(root->right);
        }
        else if (root->right->key < key) {
            root->right->right = splay(root->right->right, key);
            root = leftRotate(root);
        }

        return (root->right == NULL) ? root : leftRotate(root);
    }
}

TNode* insert(TNode *root, int k) {
    if (root == NULL) return newNode(k);

    root = splay(root, k);

    if (root->key == k) return root;

    TNode* new_node = newNode(k);

    if (root->key > k) {
        new_node->right = root;
        new_node->left = root->left;
        root->left = NULL;
    } else {
        new_node->left = root;
        new_node->right = root->right;
        root->right = NULL;
    }

    return new_node;
}

TNode* delete(TNode* root, int key) {
    if (root == NULL) return NULL;

    root = splay(root, key);

    if (root->key != key) return root;

    TNode* temp;
    if (root->left == NULL) {
        temp = root;
        root = root->right;
    } else {
        temp = root;
        root = splay(root->left, key);
        root->right = temp->right;
    }

    free(temp);
    return root;
}

void generuj_permutacje(int *tab, int n, int asc) {
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
    if (root == NULL) return 0;
    int l = height(root->left);
    int r = height(root->right);
    return 1 + max(l, r);
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

int main(int argc, char **argv) {
    init_rand();

    TNode *root = NULL;
    int n = 30;
    int asc = 0;

    if (argc >= 2) {
        n = atoi(argv[1]);
        if (argc >= 3 && !strcmp(argv[2], "1"))
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

    free(keys);
    return 0;
}
