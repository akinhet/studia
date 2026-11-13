%option noyywrap

%{
int remove_docs = 1;
%}

%%
\"([^"]|\\\")*\" ECHO;
[[:space:]]*#include[[:space:]]+<([^\n>]|\\>)*([^\\\n>]|\\>)> ECHO;
^[[:blank:]]*"///".*(\\\n.*)*\n { if (!remove_docs) ECHO; };
^[[:blank:]]*"//!".*(\\\n.*)*\n { if (!remove_docs) ECHO; };
^[[:blank:]]*"//".*(\\\n.*)*\n ;
"///".*(\\\n.*)* { if (!remove_docs) ECHO; };
"//!".*(\\\n.*)* { if (!remove_docs) ECHO; };
\/(\\\n)?\/.*(\\\n.*)* ;
"/**"[^/]([^*]|\*+[^*/])*\*+"/" { if (!remove_docs) ECHO; else printf(" "); };
"/*!"([^*]|\*+[^*/])*\*+"/" { if (!remove_docs) ECHO; else printf(" "); };
"/*"[^!*]([^*]|\*+[^*/])*\*+"/"[^[:space:]] printf(" %c", yytext[yyleng - 1]);
"/*"[^!*]([^*]|\*+[^*/])*\*+"/"\n? ;
"/**/"[^[:space:]] printf(" %c", yytext[yyleng - 1]);
"/**/"\n? ;
%%

int main(int argc, char **argv)
{

	for (int i = 1; i < argc; i++) {
		if (strcmp(argv[i], "-d") == 0)
			remove_docs = 0;
	}

	yylex();
	return 0;
}
