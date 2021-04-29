# ACD Assignment-2

This is a parser for the grammar:

```
stmts -> stmts stmt 
    | epsilon

stmt -> ;
    | expr ;
    | if (expr) stmt
    | if (expr) stmt else stmt
    | for (expr ; expr ; expr ) stmt
    | { stmts }
```

There are two input files, one with errors, one without. 

Run the following commands, in the given order:

```
lex Lexer.l
bison -d Parser.y
gcc Parser.tab.c
```

After running the given commands, run the final executable as 
```
./a.out <filename>
```

To run the input files,

   The file without any errors - `./a.out CorrectInput.c`
   The file with errors        - `./a.out IncorrectInput.c`
