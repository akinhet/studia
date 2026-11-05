#include <stdio.h>
#include <stdlib.h>
#include <math.h>

float* square_roots(float a, float b, float c)
{
	float* out = NULL;
	float delta = b*b - (a * c * 4.0);

	if (delta > 0) {
		float second_part = sqrt(delta) / (2 * a),
			  first_part  = -b / (2 * a);
		out = malloc(sizeof(float)*2);
		out[0] = first_part + second_part;
		out[1] = first_part - second_part;
	} else if (delta == 0) {
		out = malloc(sizeof(float)*2);
		out[0] = -b / (2 * a);
		out[1] = -b / (2 * a);
	}
	
	return out;
}


int main()
{
	float a, b, c;

	printf("Podaj a: ");
	scanf("%f", &a);
	printf("Podaj b: ");
	scanf("%f", &b);
	printf("Podaj c: ");
	scanf("%f", &c);

	float* roots = square_roots(a,b,c);

	if (roots == NULL) {
		printf("Ta funkcja nie ma pierwiastków.\n");
	} else {
		if (roots[0] == roots[1]) {
			printf("Pierwiastek tej funkcji to: %f\n", roots[0]);
		} else {
			printf("Pierwiastki tej funkcji to: %f, %f\n", roots[0], roots[1]);
		}
		free(roots);
	}

	return 0;
}
