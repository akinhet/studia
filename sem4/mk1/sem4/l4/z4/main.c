#include <bits/time.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define max(x, y) (x < y ? y : x)

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

typedef struct TNode {
    int key;
    struct TNode *left, *right;
    int h;
} TNode;

uint64_t current_comps = 0;
uint64_t current_ptrs = 0;

int height(TNode* root) {
    if (root == NULL) return 0;
        return root->h;
}

static void update_height(TNode* node) {
    if (node != NULL) {
        int lh = height(node->left);
        int rh = height(node->right);
        node->h = max(lh, rh) + 1;
    }
}

static TNode* newNode(int key) {
    TNode* node = (TNode*)malloc(sizeof(TNode));
    node->key = key;
    node->left = NULL;  current_ptrs++;
    node->right = NULL; current_ptrs++;
    node->h = 1;
    return node;
}
static TNode* rightRotate(TNode* x) {
    TNode* y = x->left;
    x->left = y->right; current_ptrs++;
    y->right = x;       current_ptrs++;
    update_height(x);
    update_height(y);
    return y;
}

static TNode* leftRotate(TNode* x) {
    TNode* y = x->right;
    x->right = y->left; current_ptrs++;
    y->left = x;        current_ptrs++;
    update_height(x);
    update_height(y);
    return y;
}

static TNode* splay(TNode* root, int key) {
    if (root == NULL) return NULL;

    current_comps++;
    if (root->key == key) return root;

    current_comps++;
    if (root->key > key) {
        if (root->left == NULL) return root;

        current_comps++;
        if (root->left->key > key) {
            root->left->left = splay(root->left->left, key); current_ptrs++;
            update_height(root->left);
            root = rightRotate(root);
        } else {
            current_comps++;
            if (root->left->key < key) {
                root->left->right = splay(root->left->right, key); current_ptrs++;
                update_height(root->left);
                if (root->left->right != NULL) {
                    root->left = leftRotate(root->left); current_ptrs++;
                }
            }
        }

        if (root->left == NULL) return root;
        else return rightRotate(root);
    } else {
        if (root->right == NULL) return root;

        current_comps++;
        if (root->right->key > key) {
            root->right->left = splay(root->right->left, key); current_ptrs++;
            update_height(root->right);
            if (root->right->left != NULL) {
                root->right = rightRotate(root->right); current_ptrs++;
            }
        } else {
            current_comps++;
            if (root->right->key < key) {
                root->right->right = splay(root->right->right, key); current_ptrs++;
                update_height(root->right);
                root = leftRotate(root);
            }
        }

        if (root->right == NULL) return root;
        else return leftRotate(root);
    }
}

TNode* insert(TNode *root, int k)
{
    if (root == NULL) {
        return newNode(k);
    }

    root = splay(root, k);

    current_comps++;
    if (root->key == k) return root;

    TNode* new_node = newNode(k);

    current_comps++;
    if (root->key > k) {
        new_node->right = root;       current_ptrs++;
        new_node->left = root->left;   current_ptrs++;
        root->left = NULL;            current_ptrs++;
        update_height(root);
    } else {
        new_node->left = root;        current_ptrs++;
        new_node->right = root->right; current_ptrs++;
        root->right = NULL;           current_ptrs++;
        update_height(root);
    }

    update_height(new_node);
    return new_node;
}

TNode* delete(TNode* root, int key)
{
    if (root == NULL) return NULL;

    root = splay(root, key);

    current_comps++;
    if (root->key != key) return root;

    TNode* temp = root;
    if (root->left == NULL) {
        root = root->right;
    } else {
        TNode* left_subtree = root->left;
        left_subtree = splay(left_subtree, key);
        left_subtree->right = root->right; current_ptrs++;
        root = left_subtree;
        update_height(root);
    }

    free(temp);
    return root;
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

int main(int argc, char **argv)
{
    init_rand();

    int n = 10000;
    int asc = 0;

    if (argc >= 2) n = atoi(argv[1]);
    if (argc >= 3) asc = atoi(argv[2]);

    int *keys = (int *) malloc(sizeof(int) * n);
    int num_tests = 20;

    uint64_t total_ins_comps = 0, max_ins_comps = 0;
    uint64_t total_ins_ptrs = 0, max_ins_ptrs = 0;
    uint64_t total_ins_height = 0, max_ins_height = 0;

    uint64_t total_del_comps = 0, max_del_comps = 0;
    uint64_t total_del_ptrs = 0, max_del_ptrs = 0;
    uint64_t total_del_height = 0, max_del_height = 0;

    for (int t = 0; t < num_tests; t++) {
        TNode *root = NULL;

        generuj_permutacje(keys, n, asc);
        for (int i = 0; i < n; i++) {
            current_comps = 0;
            current_ptrs = 0;

            root = insert(root, keys[i]);
            int h = height(root);

            total_ins_comps += current_comps;
            if (current_comps > max_ins_comps) max_ins_comps = current_comps;

            total_ins_ptrs += current_ptrs;
            if (current_ptrs > max_ins_ptrs) max_ins_ptrs = current_ptrs;

            total_ins_height += h;
            if ((uint64_t)h > max_ins_height) max_ins_height = h;
        }

        generuj_permutacje(keys, n, 0);
        for (int i = 0; i < n; i++) {
            current_comps = 0;
            current_ptrs = 0;

            root = delete(root, keys[i]);
            int h = height(root);

            total_del_comps += current_comps;
            if (current_comps > max_del_comps) max_del_comps = current_comps;

            total_del_ptrs += current_ptrs;
            if (current_ptrs > max_del_ptrs) max_del_ptrs = current_ptrs;

            total_del_height += h;
            if ((uint64_t)h > max_del_height) max_del_height = h;
        }
    }

    printf("%d,%d,%lu,%lu,%lu,%lu,%lu,%lu,%lu,%lu,%lu,%lu,%lu,%lu\n",
           n, asc,
           total_ins_comps, max_ins_comps,
           total_ins_ptrs, max_ins_ptrs,
           total_ins_height, max_ins_height,
           total_del_comps, max_del_comps,
           total_del_ptrs, max_del_ptrs,
           total_del_height, max_del_height);

    free(keys);
    return 0;
}
