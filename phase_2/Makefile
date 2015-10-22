snazzle.tab.c snazzle.tab.h: snazzle.y
	bison -d snazzle.y

lex.yy.c: snazzle.l snazzle.tab.h
	flex snazzle.l

syntax_analyser: lex.yy.c snazzle.tab.c snazzle.tab.h
	g++ snazzle.tab.c lex.yy.c -lfl -o syntax_analyser
