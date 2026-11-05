#include <unistd.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
	setuid(0);
	printf("real: %d\n", getuid());
	printf("effective: %d\n", geteuid());
	execlp("bash", NULL);

	return 0;
}
