parser:
	lex parser.l
	yacc -d -v parser.y
	cc lex.yy.c y.tab.c -o parser -g

clean:
	rm -f lex.yy.c y.tab.c parser y.output
