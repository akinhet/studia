#include <stdio.h>
#include "gcdlib.h"


int main()
{
	diophantes_result a = diophantes(15, 21, 9);
	printf("%d, %d\n", a.x, a.y);
}
