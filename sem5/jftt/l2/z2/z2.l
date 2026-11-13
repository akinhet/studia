%option noyywrap main
%%
\"([^"]|\"\")*\" ECHO;
^[[:space:]]*--.*\n  ;
%%
