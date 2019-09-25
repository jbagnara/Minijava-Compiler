%{
#include <stdio.h>
#include <string.h>

void yyerror(const char* str){
	printf("ono\n");
}

int yywrap(){
	return 1;
}

main(){
	yyparse();
}

%}


%token AND OR LESS GREAT LESSEQ GREATEQ EQUAL NOTEQUAL PLUS MINUS STAR SLASH

%%

commands:
	|
	commands command
	;

command:
	operators
	;

operators:
	AND | OR | LESS | GREAT | LESSEQ | GREATEQ | EQUAL | NOTEQUAL | PLUS | MINUS | STAR | SLASH
	{
		printf("yay");
	}
	;
