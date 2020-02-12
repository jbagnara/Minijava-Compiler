parser: y.tab.c lex.yy.c
	gcc lex.yy.c y.tab.c -o interpreter -g

y.tab.c: interpreter.y
	yacc -d -v interpreter.y

lex.yy.c: interpreter.l
	lex interpreter.l

clean:
	rm -f lex.yy.c y.tab.c interpreter y.output

