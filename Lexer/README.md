# ACD ASSIGNMENT-1

The lexical analyser analyses the input program and prints all tokens in it. 

Invalid tokens are defined as tokens that start with a number or a special character and containing special characters within it.

Invalid special characters are limited to '?', '#', '$', ':'.

> The input is taken from 'Input.c'.
> The output of the program is stored in a file 'Output.txt'.

To run the Lexical Analyser, run these commands:

```
lex LexicalAnalyzer.l
cc lex.yy.c
./a.out
```
