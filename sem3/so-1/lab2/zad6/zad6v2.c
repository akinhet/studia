#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <term.h>

int main(void) {
	char *truecolor = getenv("COLORTERM");
	if (truecolor != NULL && (!strcmp("truecolor", getenv("COLORTERM")) || !strcmp("24bit", getenv("COLORTERM")))) {
		for (int i = 0; i < 0xFFFFFF; i++) {
			printf("\e[38;2;%d;%d;%dmHello World\e[0m\n", i & 0xFF, (i & 0xFF00) >> 8, (i & 0xFF0000) >> 16);
		}
	} else {
		setupterm(NULL, 1, NULL);
		int num = tigetnum("colors");
		for (int i = 0; i < num; i++) {
			printf("\e[38;5;%dmHello World\e[0m\n", i);
		}
	}

  return 0;
}
