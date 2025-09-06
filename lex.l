%{
#include "yacc.tab.h"
#include <string.h>
%}

%%
0b[01]+        { yylval.s = strdup(yytext); return BINARY; }
0x[0-9A-Fa-f]+ { yylval.s = strdup(yytext); return HEXADECIMAL; }
[0-9]+         { yylval.s = strdup(yytext); return DECIMAL; }
\n             { return EOL; }
[ \t]+         { /* ignore whitespace */ }
.              { printf("Invalid input.\n"); }

%%

int yywrap() {
    return 1;
}

