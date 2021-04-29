%{
    int lines = 0;
    int keywords = 0;
    int identifiers = 0;
    int numbers = 0;
    int comments = 0;
    int invalid = 0;
%}

/* Comments */
MULTILINE_COMMENT "/*"([^*]|\*+[^/])*\*+"/"
SINGLELINE_COMMENT \/\/.*

/* Header */
PREPROCESSOR #(include[ ]?<.*>|define[^\n|^\/\/.*]+|ifdef|endif|ifndef|if|else|undef)
STDIO_FUNCTIONS printf|scanf|fopen|getc|gets|putc|puts|fclose|fgets|fputs

/* Keywords */
KEYWORD auto|struct|enum|register|typedef|extern|union|const|sizeof|volatile|static
DATATYPE double|int|long|char|float|short|unsigned|void|signed
CONTROL_STATEMENT break|continue|goto|else|switch|if|case|default|for|do|while|return

/* Identifiers */
IDENTIFIER [a-zA-Z_]+[a-zA-Z0-9_]*

/* Constants */
NUMERICAL_CONSTANT [0-9]+(\.[0-9]+)?
STRING \"[^\"\n]*\"

/* Operator */
UNARY_OPERATOR (\+\+|\-\-|&)
BINARY_OPERATOR \+|\-|\/|\*|\%
ASSIGNMENT_OPERATOR =
RELATIONAL_OPERATOR >=|>|<|<=|==|!=
BITWISE_OPERATOR &|~|\||\^|<<|>>
LOGICAL_OPERATOR &&|\|\||!

/* Miscellaneous */
PARENTHESIS \(|\)|\[|\]|\{|\}
SEMICOLON ;
COMMA ,
DOT \.

INVALID_IDENTIFIER [0-9]+[a-zA-Z_]+|[a-zA-Z0-9_\$\#:\?]*[\$\#:\?]+[a-zA-Z0-9_\$\#:\?]*

%option noyywrap

%%

\n lines++;
[\t ] ;

{SINGLELINE_COMMENT} {comments++;}
{MULTILINE_COMMENT} { 
	comments++;
	for(int i=0;i<yyleng;i++) {
		if(yytext[i]=='\n') {
			lines++;
		}
	}
}

{PREPROCESSOR} {fprintf(yyout, "Line %2d \t %30s \t ==> \tPREPROCESSOR\n", lines+1, yytext);}
{STDIO_FUNCTIONS} {fprintf(yyout, "Line %2d \t %30s \t ==> \tIDENTIFIER: HEADER FUNCTIONS\n", lines+1, yytext); identifiers++;}

{KEYWORD} {fprintf(yyout, "Line %2d \t %30s \t ==> \tKEYWORD\n", lines+1, yytext); keywords++;}
{CONTROL_STATEMENT} {fprintf(yyout, "Line %2d \t %30s \t ==> \tKEYWORD: CONTROL STATEMENT\n", lines+1, yytext); keywords++;}
{DATATYPE} {fprintf(yyout, "Line %2d \t %30s \t ==> \tKEYWORD: DATATYPE\n", lines+1, yytext); keywords++;}

{IDENTIFIER} {fprintf(yyout, "Line %2d \t %30s \t ==> \tIDENTIFIER\n", lines+1, yytext); identifiers++;}

{NUMERICAL_CONSTANT} {fprintf(yyout, "Line %2d \t %30s \t ==> \tNUMERICAL CONSTANT\n", lines+1, yytext); numbers++;}
{STRING} {fprintf(yyout, "Line %2d \t %30s \t ==> \tSTRING\n", lines+1, yytext);}

{UNARY_OPERATOR} {fprintf(yyout, "Line %2d \t %30s \t ==> \tOPERATOR: UNARY\n", lines+1, yytext);}
{BINARY_OPERATOR} {fprintf(yyout, "Line %2d \t %30s \t ==> \tOPERATOR: BINARY\n", lines+1, yytext);}
{ASSIGNMENT_OPERATOR} {fprintf(yyout, "Line %2d \t %30s \t ==> \tOPERATOR: ASSIGNMENT\n", lines+1, yytext);}
{RELATIONAL_OPERATOR} {fprintf(yyout, "Line %2d \t %30s \t ==> \tOPERATOR: RELATIONAL\n", lines+1, yytext);}
{LOGICAL_OPERATOR} {fprintf(yyout, "Line %2d \t %30s \t ==> \tOPERATOR: LOGICAL\n", lines+1, yytext);}
{BITWISE_OPERATOR} {fprintf(yyout, "Line %2d \t %30s \t ==> \tOPERATOR: BITWISE\n", lines+1, yytext);}

{PARENTHESIS} {fprintf(yyout, "Line %2d \t %30s \t ==> \tPARENTHESIS\n", lines+1, yytext);}
{SEMICOLON} {fprintf(yyout, "Line %2d \t %30s \t ==> \tSEMICOLON\n", lines+1, yytext);}
{COMMA} {fprintf(yyout, "Line %2d \t %30s \t ==> \tCOMMA\n", lines+1, yytext);}
{DOT} {fprintf(yyout, "Line %2d \t %30s \t ==> \tDOT\n", lines+1, yytext);}

{INVALID_IDENTIFIER} {fprintf(yyout, "Line %2d \t %30s \t ==> \tINVALID IDENTIFIER\n", lines+1, yytext); invalid++;}


%%

int main(){
    extern FILE *yyin, *yyout;
	yyout = fopen("Output.txt","w+");
    yyin = fopen("Input.c","r");

    printf("\nStarting Lexer...\n\nAnalysing \"Input.c\"...\n\n");

    fprintf(yyout, "\n--------------------------------------------------------------------------------\n");
    fprintf(yyout, "\t %38s \t ==> \t%s", "Lexeme", "Token");
    fprintf(yyout, "\n--------------------------------------------------------------------------------\n");

    yylex();

    fprintf(yyout, "\n--------------------------------------------------------------------------------\n");

    printf("Number of lines: %d \n", lines+1);
    printf("Number of Identifiers: %d \n", identifiers);
    printf("Number of Keywords: %d \n", keywords);
    printf("Number of Numerical Constants: %d\n", numbers);
    printf("Number of Comments: %d\n", comments);
    printf("Number of Invalid Identifiers: %d\n", invalid);

    printf("\nOutput saved to a file \"Output.txt\"\n");
    fclose(yyout);
    return 0;
}
