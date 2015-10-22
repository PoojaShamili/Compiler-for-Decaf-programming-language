%{
#include <cstdio>
#include <iostream>
#include <fstream>
#include "ast.h"
using namespace std;

// stuff from flex that bison needs to know about:
extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;
extern "C" FILE *yyout;
FILE *boutfile;
 
void yyerror(const char *s);
%}

// Bison fundamentally works by asking flex to get the next token, which it
// returns as an object of type "yystype".  But tokens could be of any
// arbitrary data type!  So we deal with that in Bison by defining a C union
// holding each of the types of tokens that Flex could return, and have Bison
// use that union instead of "int" for the definition of "yystype":
%union {
	int ival;
	float fval;
	char *sval;
	char *lval;
	bool tval;
	bool faval;
	char *cval;

	//Phase 2

	ASTnode *ast_node;
	//ASTProgram *ast_program;
	list<ASTstatement_decl_node *> *statement_list;
	ASTstatement_decl_node *statement_node;
	list<ASTfield_decl_node*> *field_list;
	ASTfield_decl_node *field_node;
	ASTlocation_node *location;
	ASTexpr_node *expr;
	list<ASTarg *> *args;
	ASTarg *arg;
	list<ASTidlist *> *idlistoflist;
	ASTidlist* idlist;

}
//constant-string tokens:
%token BOOLEAN_DECLARATION
%token CALLOUT
%token CLASS
%token <faval> FALSE
%token INT_DECLARATION
%token <tval> TRUE
%token PROGRAM
%token EQEQ
%token NE
%token PLUSEQ
%token MINUSEQ
%token GE
%token LE
%token ANDAND
%token OROR
// define the "terminal symbol" token types I'm going to use (in CAPS
// by convention), and associate each with a field of the union:
%token <ival> INT
%token <fval> FLOAT
%token <sval> ID
%token <lval> STRING
%token <cval> CHARACTER

// Phase 2

/*
%left OR
%left AND
%left EQUAL_EQUAL NOT_EQUAL
GREATER_EQUAL LESS_EQUAL
*/

%left '<' '>'
%left '+' '-' 
%left '*' '/' '%'
%left '!'
//implement unary

%type <ast_node> node;
%type <statement_list> stmt_list;
%type <statement_node> stmt_node;
%type <field_list> fld_list;
%type <field_node> fld_node;
%type <location> lctin;
%type <expr> exprsn;
%type <args> argmnts;
%type <arg> argmnt;
%type <idlistoflist> idlol;
%type <idlist> idl;
%%

program
: CLASS ID '{' fld_list stmt_list '}' 
;

fld_list
: fld_list fld_node
| fld_node
;

fld_node
: type ID ';' 
| type ID '[' INT ']' ';'
;

stmt_list
: stmt_list stmt_node
| stmt_node
;

/*statement_list
: statement_list statement_decl
| statement_decl
;
*/

stmt_node
: lctin exprsn ';' 
;

/*statement_decl
: locations expr ';' 
| callout_decl ';'
;*/

/*locations
: ID assign_op 
| ID '[' expr ']' assign_op 
;
*/

lctin
: ID assign_op
| ID '[' exprsn ']' assign_op

/*callout_decl
: CALLOUT '(' STRING args ')'
;
*/

/*args
: ',' arg_list
| %empty
;

arg_list
: arg_list ',' callout_arg
| callout_arg
;

callout_arg
: expr
| STRING
;
*/
//location 
//: ID 
//| ID '[' expr ']' 
//;

/*expr
//: location 
//: literal
: expr_prec
;

expr_prec
: expr '>' expr_one 
| expr '<' expr_one 
| expr_one
;

expr_one
: expr_one '+' expr_two 
| expr_one '-' expr_two 
| expr_two
;

expr_two
: expr_two '*' expr_three 
| expr_two '/' expr_three 
| expr_two '%' expr_three 
| expr_three
;

expr_three
: '!' expr_four
| expr_four
;

expr_four
: '-' expr_five
| expr_five
;

expr_five
: '(' expr_prec ')'
| identifier
| literal
| INT
;
*/

exprsn
: exprsn '+' exprsn
| exprsn '-' exprsn
| exprsn '*' exprsn
| exprsn '/' exprsn
| exprsn '%' exprsn
| exprsn '<' exprsn
| exprsn '>' exprsn
| identifier
| literal
| INT
;

assign_op
: '=' 
| PLUSEQ
| MINUSEQ
;

type
: INT_DECLARATION 
| BOOLEAN_DECLARATION 
;

identifier
:ID 
| ID '[' INT ']' 
;



literal
: FLOAT 
| TRUE 
| FALSE
| CHARACTER 
;
%%

int main(int argc, char** argv) {
	// open a file handle to a particular file:
	FILE *myfile = fopen(argv[1], "r");
	// make sure it is valid:
	if (!myfile) {
		cout << "I can't open " << argv[1] << endl;
		return -1;
	}
	// set flex to read from it instead of defaulting to STDIN:
	yyin = myfile;
	
	FILE *foutfile = fopen("flex_output.txt", "w+");
	boutfile = fopen("bison_output.txt", "w+");
	yyout = foutfile;
	// parse through the input until there is no more:
	do {
		yyparse();
	} while (!feof(yyin));
	fclose(myfile);
	fclose(foutfile);
}

void yyerror(const char *s) {
	cout << "Syntax Error" << endl;
	// might as well halt now:
	exit(-1);
}
