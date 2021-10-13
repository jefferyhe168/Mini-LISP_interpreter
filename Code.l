%{
    #include "Final.tab.h"    
%}

separator	[\t\n\r ]
letter		[a-z]
digit		[0-9]
number		0|[1-9]{digit}*|-[1-9]{digit}*
ID			{letter}({letter}|{digit}|-)*
true		#t
false 		#f

%%

{number} 		{ yylval.ival = atoi(yytext); return(NUMBER); }
{true} 			{ yylval.ival = 1; return(BOOL_VAL); }
{false} 		{ yylval.ival = 0; return(BOOL_VAL); }
"if" 			{ return(IF); }
"or" 			{ return(OR); }
"and" 			{ return(AND); }
"not" 			{ return(NOT); }
"mod"  			{ return(MOD); }
"define" 		{ return(DEFINE); }
"print-num"		{ return(PRINTNUM); }
"print-bool"	{ return(PRINTBOOL); }
"("|")"|"+"|"-"|"*"|"/"|">"|"<"|"="		{ return yytext[0]; }
{ID} 			{ yylval.sval = strdup(yytext); return(ID); }

.				{  }

%%

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