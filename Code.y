%{
	#include <stdio.h>
	#include <string.h>
	void yyerror(const char *msg);
	char* varname[100];
	int numarray[100];
	int idx = 0;
%}

%code requires {
	typedef struct node node;
	struct node{
		int num;
		int boolean;
		char* str;
	};
}

%union{
	int ival;
	node nval;
	char* sval;
}

%token<ival> NUMBER BOOL_VAL
%token<sval> ID
%token		PRINTNUM PRINTBOOL MOD AND OR NOT IF DEFINE

%type<nval> exp variable num_op plus multiply minus divide modulus greater smaller equal logical_op and_op or_op not_op if_exp plus_exps mul_exps equ_exps and_exps or_exps

%%
program		: stmts				{ }
			;

stmts		: stmt stmts		{ }
			| stmt				{ }
			;

stmt		: exp				{ }
			| def_stmt			{ }
			| print_stmt		{ }
			;
			
print_stmt	: '(' PRINTNUM exp ')'			{ printf("%d\n", $3.num); }
			| '(' PRINTBOOL exp ')'			{
												if($3.boolean == 0){
													printf("#f\n");
												}
												else{
													printf("#t\n");
												}
											}
			;
			
exp			: BOOL_VAL						{ $$.boolean = $1; }
			| NUMBER						{ $$.num = $1; }
			| variable						{ $$.num = $1.num; $$.boolean = $1.boolean; }
			| num_op						{ $$.num = $1.num; $$.boolean = $1.boolean; }
			| logical_op					{ $$.num = $1.num; $$.boolean = $1.boolean; }
			| if_exp						{ $$.num = $1.num; $$.boolean = $1.boolean; }
			;

num_op		: plus							{ $$.num = $1.num; $$.boolean = $1.boolean; }
			| multiply						{ $$.num = $1.num; $$.boolean = $1.boolean; }
			| minus							{ $$.num = $1.num; $$.boolean = $1.boolean; }
			| divide						{ $$.num = $1.num; $$.boolean = $1.boolean; }
			| modulus						{ $$.num = $1.num; $$.boolean = $1.boolean; }
			| greater						{ $$.num = $1.num; $$.boolean = $1.boolean; }
			| smaller						{ $$.num = $1.num; $$.boolean = $1.boolean; }
			| equal							{ $$.num = $1.num; $$.boolean = $1.boolean; }
			;
			
plus		: '(' '+' exp plus_exps ')'		{ $$.num = $3.num + $4.num; }
			;

multiply	: '(' '*' exp mul_exps ')'		{ $$.num = $3.num * $4.num; }
			;

minus		: '(' '-' exp exp ')'			{ $$.num = $3.num - $4.num; }
			;

divide		: '(' '/' exp exp ')'			{ $$.num = $3.num / $4.num; }
			;

modulus		: '(' MOD exp exp ')'			{ $$.num = $3.num % $4.num; }
			;

greater		: '(' '>' exp exp ')'			{ $$.boolean = ($3.num > $4.num); }
			;

smaller		: '(' '<' exp exp ')'			{ $$.boolean = ($3.num < $4.num); }
			;

equal		: '(' '=' exp equ_exps ')'		{ $$.boolean = ($4.boolean && ($3.num == $4.num)); }
			;
			
plus_exps	: exp plus_exps					{ $$.num = $1.num + $2.num; }
			| exp							{ $$.num = $1.num; }
			;

mul_exps	: exp mul_exps					{ $$.num = $1.num * $2.num; }
			| exp							{ $$.num = $1.num; }
			;

equ_exps	: exp equ_exps					{ $$.boolean = ($2.boolean && ($1.num == $2.num)); }
			| exp							{ $$.num = $1.num; $$.boolean = 1; }
			;

logical_op	: and_op						{ $$.num = $1.num; $$.boolean = $1.boolean; }
			| or_op							{ $$.num = $1.num; $$.boolean = $1.boolean; }
			| not_op						{ $$.num = $1.num; $$.boolean = $1.boolean; }
			;

and_op		: '(' AND exp and_exps ')'		{ $$.boolean = ($3.boolean && $4.boolean); }
			;

or_op		: '(' OR exp or_exps ')'		{ $$.boolean = ($3.boolean || $4.boolean); }
			;

not_op		: '(' NOT exp ')'				{ $$.boolean = !($3.boolean); }
			;

and_exps	: exp and_exps					{ $$.boolean = ($1.boolean && $2.boolean); }
			| exp							{ $$.boolean = $1.boolean; }
			;

or_exps		: exp or_exps					{ $$.boolean = ($1.boolean || $2.boolean); }
			| exp							{ $$.boolean = $1.boolean; }
			;
			
if_exp		: '(' IF exp exp exp ')'		{
												if($3.boolean == 0) {
													$$.boolean = $5.boolean;
													$$.num = $5.num;
												}
												else {
													$$.boolean = $4.boolean;
													$$.num = $4.num;
												}			
											}
			;
			
def_stmt	: '(' DEFINE variable exp ')'	{
												varname[idx] = $3.str;
												numarray[idx++] = $4.num;
											}
			;
variable	: ID							{
												int i;
												for(i = 0; i < idx; i++) {
													if(strcmp(varname[i], $1) == 0) {
														$$.str = $1;
														$$.num = numarray[i];
														break;
													}
												}
												if(i >= idx)
													$$.str = $1;
											}
			;

%%

void yyerror(const char *msg){	
	fprintf(stderr, "%s\n", msg);
}
int main(int argc, char** argv)
{
    yyparse();
    return 0;
}

/*
sudo mount -t vboxsf share /home/user/Desktop/DomjudgeHW2 
bison -d -o Final.tab.c Final.y
gcc -c -g -I.. Final.tab.c
flex -o Final.yy.c Final.l
gcc -c -g -I.. Final.yy.c
gcc -o Final Final.tab.o Final.yy.o -ll
./Final < 01_1.lsp
./smli < 01_1.lsp
*/