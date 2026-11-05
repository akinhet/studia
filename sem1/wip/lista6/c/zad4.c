#include <stdio.h>
#include <stdbool.h>

#define MAX_N 20

int position[MAX_N];
bool bije_wiersz[MAX_N];
bool bije_przek1[2 * MAX_N];
bool bije_przek2[2 * MAX_N];


void drukuj_rozwiazanie(int n)
{
    for (int i = 1; i <= n; i++)
        printf("%d ", position[i]);
    printf("\n");
}


void ustaw(int i, int n)
{
    for (int j = 1; j <= n; j++) {
        if (!bije_wiersz[j] && !bije_przek1[i + j] && !bije_przek2[i - j + n]) {
            position[i] = j;
            bije_wiersz[j] = true;
            bije_przek1[i + j] = true;
            bije_przek2[i - j + n] = true;

            if (i < n) {
                ustaw(i + 1, n);
            } else {
                drukuj_rozwiazanie(n);
            }

            position[i] = 0;
            bije_wiersz[j] = false;
            bije_przek1[i + j] = false;
            bije_przek2[i - j + n] = false;
        }
    }
}


int main(int argc, char **argv)
{
    int n = 0;
	if (argc != 2) {
		printf("usage: %s [number of queens]\n", argv[0]);
		return 1;
	}

	sscanf(argv[1], "%d", &n);
	if (n <= 0) {
		printf("ERROR: bad argument: %s\n", argv[1]);
		return 2;
	}

    if (n < 1 || n > MAX_N) {
        printf("n musi być liczbą całkowitą z zakresu 1-%d.\n", MAX_N);
        return 3;
    }

    for (int i = 0; i < MAX_N; i++) {
        position[i] = 0;
        bije_wiersz[i] = false;
    }
    for (int i = 0; i < 2 * MAX_N; i++) {
        bije_przek1[i] = false;
        bije_przek2[i] = false;
    }

    ustaw(1, n);

    return 0;
}
