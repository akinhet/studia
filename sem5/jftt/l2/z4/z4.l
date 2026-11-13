%option noyywrap nodefault

%{
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <errno.h>
#include <string.h>

#define MAX_STACK 1024

long long stack[MAX_STACK];
int top = 0;
int has_input = 0;
char error[128] = "";

void set_error(const char *msg)
{
	if (!error[0])
		snprintf(error, sizeof(error), "%s", msg);
}

void push(long long x)
{
	if (top >= MAX_STACK) {
		set_error("przepełnienie stosu");
		return;
	}

	stack[top++] = x;
}

void calculate(char op)
{
	if (error[0])
		return;

	if (top < 2) {
		set_error("za mała liczba argumentów");
		return;
	}

	long long b = stack[--top];
	long long a = stack[--top];
	long long result = 0;

	switch (op) {
	case '+':
		result = a + b;
		break;

	case '-':
		result = a - b;
		break;

	case '*':
		result = a * b;
		break;

	case '/':
	case '%':
		if (b == 0) {
			set_error("dzielenie przez zero");
			return;
		}

		if (a == INT64_MIN && b == -1) {
			set_error("przepełnienie arytmetyczne");
			return;
		}

		result = op == '/' ? a / b : a % b;
		break;

	case '^':
		if (b < 0) {
			set_error("ujemny wykładnik");
			return;
		}

		result = 1;
		while (b > 0) {
			if (b & 1) {
				result *= a;
			}

			b >>= 1;
			if (b > 0) {
				a *= a;
			}
		}
		break;
	}

	push(result);
}

void finish_line(void)
{
	if (!has_input)
		return;

	if (error[0])
		printf("Błąd: %s\n", error);
	else if (top > 1)
		printf("Błąd: za mała liczba operatorów\n");
	else if (top == 0)
		printf("Błąd: za mała liczba argumentów\n");
	else
		printf("= %lld\n", stack[0]);

	top = 0;
	has_input = 0;
	error[0] = '\0';
}
%}

%%

-?[0-9]+ {
	has_input = 1;

	if (!error[0]) {
		errno = 0;
		long long value = strtoll(yytext, NULL, 10);

		if (errno == ERANGE)
			set_error("liczba poza zakresem");
		else
			push(value);
	}
}

[+*/%^ -] {
	if (yytext[0] != ' ') {
		has_input = 1;
		calculate(yytext[0]);
	}
}

[\t\r]+	;

\n {
	finish_line();
}

. {
	has_input = 1;
	if (!error[0]) {
		snprintf(error, sizeof(error),
				 "zły symbol \"%s\"", yytext);
	}
}

<<EOF>> {
	finish_line();
	return 0;
}

%%

int main(void)
{
	yylex();
	return 0;
}
