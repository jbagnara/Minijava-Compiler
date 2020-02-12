mjavac: y.tab.c lex.yy.c
	gcc lex.yy.c y.tab.c -o mjavac -g

y.tab.c: compiler.y
	yacc -d -v compiler.y

lex.yy.c: compiler.l
	lex compiler.l

clean:
	rm -f lex.yy.c y.tab.c mjavac y.output

