%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>
    #include <stdbool.h>

    int yyerror(char *s);

    extern int line;
    extern int col;
    extern char *yytext;
    extern errors;

    bool pass = true;
%}

%union
{
  char *string;
  float number;
}

/* Define token datatypes */

%token <string> IDENTIFIER
%token IF UNARY
%token ASSIGNMENT
%token ELSE
%token FOR
%token OPERATOR
%token <string> DATATYPE
%token <number> NUMBER

/* Assign priorities */

%left UNARY
%left DATATYPE
%left OPERATOR
%left ASSIGNMENT

%nonassoc NO_ELSE
%nonassoc ELSE

%start code

%%

code : stmts
        ;

stmts : stmts stmt
        | %empty
        ; 

stmt  : ';'
      | expr ';' 
      | IF '(' expr ')' stmt ELSE stmt 
      | IF '(' expr ')' stmt %prec NO_ELSE
      | FOR '(' expr ';' expr ';' expr ')' stmt
      | '{' stmts '}'
      ;

expr : TERMINAL
     | UNARY IDENTIFIER
     | IDENTIFIER UNARY
     | TERMINAL OPERATOR expr
     | DATATYPE expr
     | IDENTIFIER ASSIGNMENT expr
     | error
     ;

TERMINAL  : IDENTIFIER
          | NUMBER
          ;

%%

#include "lex.yy.c"

int main(int argc, char** argv) {
    col = 1;
    line = 1;
    if(argc != 2) {
        printf("FILE NAME EMPTY. PLEASE GIVE INPUT IN FORMAT:\n./a.out <file_name>\n");
        return 1;
    }
    freopen(argv[1], "r", stdin);
    yyparse();
    if (pass) {
        printf("\n\033[1;32m OK \033[0m\n");
        return 0;
    }
    else printf("\033[1;31m\tCOMPILATION FAILED, FOUND %d ERROR(S) \033[0m \n", errors);
    return 1;
}

int yyerror(char *error) {
    printf("\033[1;31mERROR: %s\n\033[0m  YACC: Syntax error near line %d and col %d and near \"%s\"\n\n", error, line, col, yytext);
    pass = false;
    errors++;
    return 1;
}