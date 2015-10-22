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

	//ASTnode *ast_node;
	ASTProgram *ast_program;
	list<ASTstatement_decl_node *> *statement_list;
	ASTstatement_decl_node *statement_node;
	list<ASTfield_decl_node*> *field_list;
	ASTfield_decl_node *field_node;
	ASTlocation_node *location;
	ASTexpr_node *expr;
//	list<ASTarg *> *args;
//	ASTarg *arg;
	list<ASTidlist *> *idlistoflist;
	ASTidlist* idlist;
	ASTidentifier* idnt;
	ASTliteral* lit;
	ASTtype* typ;
	ASTassign_op* as_op;
	ASTint* in;
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

%left '<' '>'
%left '+' '-' 
%left '*' '/' '%'
%left '!'
//implement unary

//%type <ast_node> node;
%type <ast_program> program;
%type <statement_list> stmt_list;
%type <statement_node> stmt_node;
%type <field_list> fld_list;
%type <field_node> fld_node;
%type <location> lctin;
%type <expr> exprsn;
//%type <args> argmnts;
//%type <arg> argmnt;
%type <idlistoflist> idlol id_single;
//%type <idlist> idl;
%type <idnt> identifier;
%type <lit> literal;
%type <typ> type;
%type <as_op> assign_op;
%type <in> int;
%%

program
: CLASS PROGRAM '{' fld_list stmt_list '}' {$$ = new ASTProgram($4,$5);root=$$;}
;

fld_list
: /*epsilon*/ {$$ = new list<ASTfield_decl_node*>();}
| fld_list fld_node {$$ = $1; $$ -> push_back($2);}
;

fld_node
: type idlol ';' {$$ = new field_decl_node($1, $2);}
;

idlol
: ID id_single {ASTid *x = new ASTid($1); $2 -> push_front(x); $$ = $2;}
| ID '[' INT ']' id_single {ASTid_string *y = new ASTid_string($1, $3); $5 -> push_front(y); $$ = $5;}
;

id_single
: ',' ID id_single {ASTid *x = new ASTid($2); $3 -> push_front(x); $$ = $3;}
| ',' ID '[' INT ']' id_single {ASTid_string *y = new ASTid_string($2, $4); $6 -> push_front(y); $$ = $6;}
| /*epsilon*/ {$$ = new list<ASTidlist*>();}
;

stmt_list
: stmt_list stmt_node {$$ = $1; $$ -> push_back($2);}
| /*epsilon*/ {$$ = new list<ASTstatement_decl_node*>();}
;

stmt_node
: lctin exprsn ';' {$$ = new ASTstatement_decl_node($1, $2);}

lctin
: ID assign_op {ASTid *i = new ASTid($1); ASTlocation_single *x = new ASTlocation_node(i, $2); ASTlocation_node *y = x; $$ = y;}
| ID '[' exprsn ']' assign_op {ASTid *i = new ASTid($1); ASTlocation_array *x = new ASTlocation_array(i, $5, $3); ASTlocation_node *y = x; $$ = y;}

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


exprsn
: exprsn '+' exprsn {$$ = new ASTbinary_expr_node($1, $3, '+');}
| exprsn '-' exprsn {$$ = new ASTbinary_expr_node($1, $3, '-');}
| exprsn '*' exprsn {$$ = new ASTbinary_expr_node($1, $3, '*');}
| exprsn '/' exprsn {$$ = new ASTbinary_expr_node($1, $3, '/');}
| exprsn '%' exprsn {$$ = new ASTbinary_expr_node($1, $3, '%');}
| exprsn '<' exprsn {$$ = new ASTbinary_expr_node($1, $3, '<');}
| exprsn '>' exprsn {$$ = new ASTbinary_expr_node($1, $3, '>');}
| identifier {$$ = $1;}
| literal {$$ = $1;}
| int {$$ = $1);}
;

int
: INT {$$ = new ASTint($1);}
;

assign_op
: '=' {$$ = new ASTassign_op('=');}
| PLUSEQ {$$ = new ASTassign_op("+=");}
| MINUSEQ {$$ = new ASTassign_op("-=");}
;

type
: INT_DECLARATION {$$ = new ASTtype("int");}
| BOOLEAN_DECLARATION {$$ = new ASTtype("bool");}
;

identifier
:ID {ASTid* x = new ASTid($1); $$ = new ASTidentifier(x);}
| ID '[' INT ']' {ASTid_array* x = new ASTid_array($1, $3); $$ = ASTidentifier(x);} 
;



literal
: FLOAT {$$ = new ASTliteral($1);}
| TRUE {$$ = new ASTliteral($1);}
| FALSE {$$ = new ASTliteral($1);}
| CHARACTER {$$ = new ASTliteral($1);}
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
