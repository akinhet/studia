#include <stdio.h>

int NWD(int a, int b)
{
	int temp;

	if (a < 0) {
		a = -a;
	}
	if (b < 0) {
		b = -b;
	}

	while (b > 0) {
		temp = a;
		a = b;
		b = temp % b;
	}

	return a;
}


int main()
{
	int a, b;

	printf("Podaj pierwszą liczbę: ");
	scanf("%d", &a);
	printf("Podaj drugą liczbę: ");
	scanf("%d", &b);

	int out = NWD(a, b);
	printf("NWD liczb %d i %d wynosi %d.\n", a, b, out);

	return 1;
}
