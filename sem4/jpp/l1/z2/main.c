#include "gcd_lib.h"
#include <stdio.h>

int main()
{
	diophantes_result a = diophantes(15, 9, 6);
	printf("%d, %d\n", a.x, a.y);
}
