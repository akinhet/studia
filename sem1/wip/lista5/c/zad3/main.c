#include <stdio.h>
#include <math.h>

typedef double (*functype)(double);


double findzero(functype f, double a, double b, double eps)
{
	if (a >= b || f(a) * f(b) >= 0)
		return a;

	double start = a,
		   end   = b,
		   mid;

	while ((end - start) > eps) {
		mid = (start + end) / 2;

		if (f(mid) == 0)
			return mid;

		if (f(start) * f(mid) < 0)
			end = mid;
		else
			start = mid;
	}

	return mid;
}


double halfcos(double x)
{
	return cos(x/2);
}


int main()
{
	double eps = 0.1;
	for (int i = 0; i < 8; i++) {
		printf("%.20f\n", findzero(halfcos, 2, 4, eps));
		eps /= 10;
	}
}
