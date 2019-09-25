parser:
	lex parser.l
	yacc -d parser.y
	cc lex.yy.c y.tab.c -o parser

clean:
	rm -f lex.yy.c y.tab.c parser
