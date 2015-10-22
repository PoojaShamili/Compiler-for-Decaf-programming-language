/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_SNAZZLE_TAB_H_INCLUDED
# define YY_YY_SNAZZLE_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    BOOLEAN_DECLARATION = 258,
    CALLOUT = 259,
    CLASS = 260,
    FALSE = 261,
    INT_DECLARATION = 262,
    TRUE = 263,
    PROGRAM = 264,
    EQEQ = 265,
    NE = 266,
    PLUSEQ = 267,
    MINUSEQ = 268,
    GE = 269,
    LE = 270,
    ANDAND = 271,
    OROR = 272,
    INT = 273,
    FLOAT = 274,
    ID = 275,
    STRING = 276,
    CHARACTER = 277
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 23 "snazzle.y" /* yacc.c:1909  */

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

#line 107 "snazzle.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_SNAZZLE_TAB_H_INCLUDED  */
