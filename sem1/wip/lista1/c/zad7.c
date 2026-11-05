#include <stdio.h>


int main()
{
	int n, p;

	printf("Podaj liczbę: ");
	scanf("%d", &n);
	printf("Podaj podstawę: ");
	scanf("%d", &p);

	int num = n,
		out;

	while (num > 0) {
		out *= p;
		out += num % p;
		num /= p;
	}

	if (n == out) {
		printf("Liczba %d jest palindromem w podstawie %d.\n", n, p);
	} else {
		printf("Liczba %d nie jest palindromem w podstawie %d.\n", n, p);
	}

	return 0;
}
