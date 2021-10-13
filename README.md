# Mini-LISP_interpreter

#### This is an interpreter for Mini-LISP, which implement features of the language.

### Environment
Virtual box(Linux environment) from TA of NCU Compiler course

### Language
Yacc & Lex

### How to compile
`bison -d -o Final.tab.c Final.y`
`gcc -c -g -I.. Final.tab.c`
`flex -o Final.yy.c Final.l`
`gcc -c -g -I.. Final.yy.c`
`gcc -o Final Final.tab.o Final.yy.o -ll`

### Function that this interpreter provide
1. Syntax Validation
2. Print
3. Numerical Operations
4. Logical Operations
5. if Expression
6. Variable Definition
