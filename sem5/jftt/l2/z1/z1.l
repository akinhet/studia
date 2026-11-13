%option noyywrap main
%%
	int wc = 0, lc = 0;

\n+           printf("\n"); lc++;
^[[:space:]]+ ;
[[:space:]]+$ ;
[[:blank:]]+  printf(" ");
[^[:space:]]+ wc++; ECHO;

<<EOF>> printf("%d %d\n", wc, lc); yyterminate();
%%
