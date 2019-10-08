parser: y.tab.c lex.yy.c
	gcc lex.yy.c y.tab.c -o parser -g

y.tab.c: parser.y
	yacc -d -v parser.y

lex.yy.c: parser.l
	lex parser.l

clean:
	rm -f lex.yy.c y.tab.c parser y.output
