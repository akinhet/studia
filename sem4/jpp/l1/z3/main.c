#include <stdio.h>
#include "gcd_lib.h"

int main()
{
	diophantes_result a = diophantes(15, 9, 6);
	printf("%d, %d\n", a.x, a.y);
	// int a = gcd(15, 9);
	// printf("%d\n", a);
}
