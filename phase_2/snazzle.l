%{
#include <cstdio>
#include <iostream>
#include<stdio.h>
using namespace std;
#define YY_DECL extern "C" int yylex()

#include "snazzle.tab.h"  // to get the token types that we return

%}
%%
[\t];
[\n] {fprintf(yyout, "");}
boolean {fprintf(yyout, "BOOLEAN_DECLARATION\n"); return BOOLEAN_DECLARATION;}
callout {fprintf(yyout, "CALLOUT\n"); return CALLOUT;}
class {fprintf(yyout, "CLASS\n"); return CLASS;}
false {yylval.faval = strdup(yytext); fprintf(yyout, "BOOLEAN: false\n"); return FALSE;}
int {fprintf(yyout, "INT_DECLARATION\n"); return INT_DECLARATION;}
true {yylval.tval = strdup(yytext); fprintf(yyout, "BOOLEAN: true\n"); return TRUE;}
[\{] {return '{';}
[\}] {return '}';}
[\(] {return '(';}
[\)] {return ')';}
[;] {return ';';}
\[ {return '[';}
\] {return ']';}
\+ {return '+';}
- {return '-';}
\* {return '*';}
\/ {return '/';}
% {return '%';}
&& {return ANDAND;}
\|\| {return OROR;}
= {return '=';}
\+= {return PLUSEQ;}
-= {return MINUSEQ;}
\< {return '<';}
\> {return '>';}
\<= {return LE;}
\>= {return GE;}
== {return EQEQ;}
\!= {return NE;}
, {return ',';}
\! {return '!';}

[0-9]+\.[0-9]+ {fprintf(yyout, "FLOAT: %f\n", atof(yytext)); yylval.fval = atof(yytext); return FLOAT; }
[0-9]+            {fprintf(yyout, "INT: %d\n", atoi(yytext)); yylval.ival = atoi(yytext); return INT; } 
[a-zA-Z0-9]+      {
	// we have to copy because we cant rely on yytext not changing underneath us:
	fprintf(yyout, "ID: %s\n", strdup(yytext));
	yylval.sval = strdup(yytext);
	return ID;
}
["][a-zA-Z0-9]+["] {
	fprintf(yyout, "STRING: %s\n", strdup(yytext));
	yylval.lval = strdup(yytext);
	return STRING;
}
[\'][a-z][\'] {
	fprintf(yyout, "CHARACTER: %s\n", strdup(yytext));
	yylval.cval = strdup(yytext);
	return CHARACTER;
}
.                ;
%%
