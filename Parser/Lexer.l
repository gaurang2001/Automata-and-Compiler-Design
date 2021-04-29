%{
	#include "Parser.tab.h"
	#include <string.h>
	#include <stdlib.h>

	int line = 0;
	int col = 0;
	int errors = 0;
%}

/* Comments */
MULTILINE_COMMENT "/*"([^*]|\*+[^/])*\*+"/"
SINGLELINE_COMMENT \/\/.*

/* Datatypes */
DATATYPES double|int|long|char|float|short|unsigned|void|signed

/* Identifier */
IDENTIFIERS [a-zA-Z_]+[a-zA-Z0-9_]*

/* Operators */
UNARY_OPERATOR (\+\+|\-\-|&)
BINARY_OPERATOR \+|\-|\/|\*|\%
RELATIONAL_OPERATOR >=|>|<|<=|==|!=
BITWISE_OPERATOR &|~|\||\^|<<|>>
LOGICAL_OPERATOR &&|\|\||!

/* Assignment Operators and Shorthands */
ASSIGNMENT_OPERATOR =|\+=|-=|\/=|%=|\*=

/* Numbers */
NUMERICAL_CONSTANT [0-9]+(\.[0-9]+)?

/* Miscellaneous */
PARENTHESIS \(|\)|\[|\]|\{|\}
SEMICOLON ;
COMMA ,
DOT \.

%%

\n { line++; col = 1; }

[\t ] { col += yyleng; }

{SINGLELINE_COMMENT} { col += yyleng; }
{MULTILINE_COMMENT} {
	for(int i=0;i<yyleng;i++) {
		col++;
		if(yytext[i]=='\n') {
			line++;
			col = 1;
		}
	}
}

{PARENTHESIS}|{SEMICOLON}|{COMMA}|{DOT} { col += yyleng; return yytext[0]; } 
"if"       { col += 2; return IF; }
"else"     { col += 4; return ELSE; }
"for"      { col += 3; return FOR; }
{NUMERICAL_CONSTANT} { col += yyleng; return NUMBER; }
{UNARY_OPERATOR} { col += yyleng; return UNARY; }
{ASSIGNMENT_OPERATOR} { col += yyleng; return ASSIGNMENT; }
{BINARY_OPERATOR}|{RELATIONAL_OPERATOR}|{BITWISE_OPERATOR}|{LOGICAL_OPERATOR}  {col += yyleng; return OPERATOR; }
{DATATYPES} { col += yyleng; return DATATYPE; }
{IDENTIFIERS} { col += yyleng; return IDENTIFIER; }

. { printf("\033[1;31mERROR: lexical error\n\033[0m  LEX: Error, Cannot recognise token near line %d, and col %d : \" %s \" \n\n", line, col, yytext); errors++; }

%% 

int yywrap()  { return 1; }
