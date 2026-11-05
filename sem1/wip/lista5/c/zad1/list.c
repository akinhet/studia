#include <stdlib.h>
#include <stdio.h>
#include "list.h"


bool is_empty(list l)
{
	if (l == NULL)
		return true;
	return l->first == NULL;
}


int pop(list l)
{
	if (is_empty(l))
		return 0;

	node_ptr cursor = l->first;
	int val = cursor->elem;

	if (l->first == l->last)
		l->last = NULL;
	l->first = l->first->next;

	l->length--;

	free(cursor);

	return val;
}


void push(list l, int e)
{
	node_ptr cursor = (node_ptr) malloc(sizeof(node));
	cursor->elem = e;
	cursor->next = l->first;

	if (is_empty(l)) {
		l->last = cursor;
		l->length = 0;
	}

	l->first = cursor;

	l->length++;
}


void append(list l, int e)
{
	node_ptr cursor = (node_ptr) malloc(sizeof(node));
	cursor->elem = e;
	
	if (is_empty(l)) {
		l->first = (l->last = cursor);
		l->length = 0;
	} else {
		l->last->next = cursor;
		l->last = cursor;
	}

	l->length++;
}


int get(list l, int i)
{
	if (is_empty(l))
		return 0;

	node_ptr cursor = l->first;

	int idx = 0;
	while (idx < i && cursor->next != NULL) {
		cursor = cursor->next;
		idx++;
	}

	if (idx != i) {
		return 0;
	}

	return cursor->elem;
}


void put(list l, int i, int e)
{
	if (is_empty(l))
		return;

	node_ptr cursor = l->first;

	int idx = 0;
	while (idx < i && cursor->next != NULL) {
		cursor = cursor->next;
		idx++;
	}

	if (cursor != NULL && idx == i)
		cursor->elem = e;
}


void insert(list l, int i, int e)
{
	if (is_empty(l))
		return;

	if (i == 0) {
		node_ptr newnode = (node_ptr) malloc(sizeof(node));
		newnode->elem = e;
		newnode->next = l->first;
		l->first = newnode;

		l->length++;

		if (newnode->next == NULL)
			l->last = newnode;

		return;
	}

	node_ptr cursor = l->first;

	int idx = 0;
	while (idx < i - 1 && cursor->next != NULL) {
		cursor = cursor->next;
		idx++;
	}

	if (cursor == NULL || idx != i - 1) {
		return;
	}

	node_ptr newnode = (node_ptr) malloc(sizeof(node));
	newnode->elem = e;
	newnode->next = cursor->next;
	cursor->next = newnode;

	l->length++;

	if (newnode->next == NULL)
		l->last = newnode;
}


void delete(list l, int i)
{
	if(is_empty(l))
		return;

	if (i == 0) {
		node_ptr todel = l->first;
		
		l->first = l->first->next;
		if (l->first == NULL)
			l->last = NULL;

		l->length--;
		
		free(todel);
		return;
	}

	node_ptr cursor = l->first;
	int idx = 0;
	while (idx < i - 1 && cursor->next != NULL) {
		cursor = cursor->next;
		idx++;
	}

	if (cursor->next == NULL || idx != i - 1) {
		return;
	}

	node_ptr todel = cursor->next;
	cursor->next = todel->next;

	l->length--;

	free(todel);
}


void print(list l)
{
	if (is_empty(l)) {
		printf("( 0 )\n");
		return;
	}

	node_ptr cursor = l->first;

	do {
		printf("%d ", cursor->elem);
	} while ((cursor = cursor->next) != NULL);

	printf("( %d )\n", l->length);
}


void clean(list l)
{
	if (is_empty(l))
		return;

	node_ptr cursor = l->first;

	while (cursor != NULL) {
		node_ptr todel = cursor;
		cursor = cursor->next;
		free(todel);
	}

	l->first = l->last = NULL;
	l->length = 0;
}


int length(list l)
{
	if (is_empty(l))
		return 0;
	
	return l->length;
}
