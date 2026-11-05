#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct {
  int Bn, Un, Cn, Dn, diff;
} result_t;

// --- msws32 ---
#include "init.h"
#include <time.h>

// uint64_t x = 0, w = 0, s = 0xb5ad4eceda1ce2a9;
uint64_t x, w, s;

static void init_rand() { x = w = s = init_rand_digits(time(NULL)); }

inline static uint32_t my_rand() {
  x *= x;
  x += (w += s);
  return x = (x >> 32) | (x << 32);
}

// --- xoshiro256++ ---
/*
uint64_t rol64(uint64_t x, int k) { return (x << k) | (x >> (64 - k)); }

struct xoshiro256pp_state {
  uint64_t s[4];
} state;

uint64_t my_rand() {
  uint64_t *s = state.s;
  uint64_t const result = rol64(s[0] + s[3], 23) + s[0];
  uint64_t const t = s[1] << 17;

  s[2] ^= s[0];
  s[3] ^= s[1];
  s[1] ^= s[2];
  s[0] ^= s[3];

  s[2] ^= t;
  s[3] = rol64(s[3], 45);

  return result;
}
*/

result_t run_experiment(int n) {
  int *counts = calloc(n, sizeof(int));
  int empty = n;
  int one_ball = n;

  int seen_once = 0;
  int Bn = 0, Un = 0, Cn = 0, Dn = 0;

  int k = 0;
  while (1) {
    k++;
    int urn = my_rand() % n;
    int prev = counts[urn];
    counts[urn]++;

    if (prev == 1 && Bn == 0)
      Bn = k;

    if (k <= n) {
      if (prev == 0)
        empty--;
      if (k == n)
        Un = empty;
    }

    if (prev == 0) {
      seen_once++;
      if (seen_once == n)
        Cn = k;
    }

    if (prev == 1) {
      one_ball--;
      if (one_ball == 0) {
        Dn = k;
        break;
      }
    }
  }

  free(counts);

  result_t r;
  r.Bn = Bn;
  r.Un = Un;
  r.Cn = Cn;
  r.Dn = Dn;
  r.diff = Dn - Cn;
  return r;
}

int main(int argc, char *argv[]) {
  init_rand();

  FILE *f;

  if (argc == 2) {
    f = fopen(argv[1], "w");
  } else {
    f = fopen("wyniki.csv", "w");
  }

  if (!f) {
    printf("Nie można otworzyć pliku\n");
    return 1;
  }

  fprintf(f, "n,Bn,Un,Cn,Dn,Dn-Cn\n");

  for (int n = 1000; n <= 100000; n += 1000) {
    for (int rep = 1; rep <= 50; rep++) {
      result_t r = run_experiment(n);
      fprintf(f, "%d,%d,%d,%d,%d,%d\n", n, r.Bn, r.Un, r.Cn, r.Dn, r.diff);
    }
    printf("n = %d zrobione.\n", n);
  }

  fclose(f);
  return 0;
}
