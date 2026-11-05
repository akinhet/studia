#include <stdlib.h>
#include <stdio.h>
#include <readline/readline.h>
#include <readline/history.h>

#include "list.h"


int main(int argc, char** argv)
{
	char* buf;
	list_t lista;

	while ((buf = readline(">> ")) != NULL) {
		if (strlen(buf) == 0)
			continue;

		add_history(buf);

		if (!strcmp(buf, "pop")) {
			if(is_empty(&lista)) {
				printf("ERROR: list is empty\n");
				continue;
			}
			printf("%d\n", pop(&lista));

		} else if (!strcmp(buf, "push")) {
			int val;
			printf("Value: ");
			scanf("%d", &val);
			push(&lista, val);

		} else if (!strcmp(buf, "append")) {
			int val;
			printf("Value: ");
			scanf("%d", &val);
			append(&lista, val);

		} else if (!strcmp(buf, "get")) {
			int idx;
			printf("Index: ");
			scanf("%d", &idx);
			if (idx >= length(&lista) || idx < 0) {
				printf("ERROR: index out of range\n");
				continue;
			}
			printf("%d\n", get(&lista, idx));

		} else if (!strcmp(buf, "put")) {
			int idx, val;
			printf("Index: ");
			scanf("%d", &idx);
			if (idx >= length(&lista) || idx < 0) {
				printf("ERROR: index out of range\n");
				continue;
			}
			printf("Value: ");
			scanf("%d", &val);
			put(&lista, idx, val);

		} else if (!strcmp(buf, "insert")) {
			int idx, val;
			printf("Index: ");
			scanf("%d", &idx);
			if (idx > length(&lista) || idx < 0) {
				printf("ERROR: index out of range\n");
				continue;
			}
			printf("Value: ");
			scanf("%d", &val);
			insert(&lista, idx, val);

		} else if (!strcmp(buf, "delete")) {
			int idx;
			printf("Index: ");
			scanf("%d", &idx);
			if (idx >= length(&lista) || idx < 0) {
				printf("ERROR: index out of range\n");
				continue;
			}
			delete(&lista, idx);

		} else if (!strcmp(buf, "print")) {
			print(&lista);

		} else if (!strcmp(buf, "clean")) {
			clean(&lista);

		} else if (!strcmp(buf, "length")) {
			printf("%d\n", length(&lista));

		} else {
			printf("ERROR: unkown command '%s'\n", buf);
		}

		free(buf);
	}
}
