%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Declare these for the parser
int yylex();
void yyerror(const char *msg);
void convert_and_print(char *input);
%}

%union {
    char *s;
}

%token <s> BINARY HEXADECIMAL DECIMAL
%token EOL

%type <s> number
%type <s> line

%%

input:
    /* empty */
    | input line
    ;

line:
    number EOL {
        convert_and_print($1);
        free($1);
    }
    ;

number:
    BINARY        { $$ = $1; }
    | HEXADECIMAL { $$ = $1; }
    | DECIMAL     { $$ = $1; }
    ;

%%

void convert_and_print(char *input) {
    long value = 0;

    if (strncmp(input, "0b", 2) == 0) {
        value = strtol(input + 2, NULL, 2);
    } else if (strncmp(input, "0x", 2) == 0) {
        value = strtol(input + 2, NULL, 16);
    } else {
        value = strtol(input, NULL, 10);
    }

    printf("Decimal: %ld\n", value);
    printf("Hexadecimal: 0x%lX\n", value);
    printf("Binary: 0b");

    int started = 0;
    for (int i = sizeof(long) * 8 - 1; i >= 0; i--) {
        int bit = (value >> i) & 1;
        if (bit) started = 1;
        if (started) printf("%d", bit);
    }
    if (!started) printf("0");
    printf("\n");
}

// Dummy yyerror for parser error handling
void yyerror(const char *msg) {
    fprintf(stderr, "Error: %s\n", msg);
}

// main function
int main() {
    printf("Enter a number (0b for binary, 0x for hex, plain for decimal), one per line:\n");
    return yyparse();
}

