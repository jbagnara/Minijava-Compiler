%{
#include <stdio.h>
#include <string.h>

extern int yylineno;

void yyerror(const char* str){
	printf("Syntax errors found in line number %d\n", yylineno);
}

int yywrap(){
	return 1;
}

main(){
	yyparse();
}

%}


%token AND OR LESS GREAT LESSEQ GREATEQ EQUAL NOTEQUAL PLUS MINUS STAR SLASH LBRACK RBRACK LBRACE RBRACE LPARENTH RPARENTH EXTENDS HEADER STRING_LITERAL WORD STRINGDECL CLASS IF WHILE NOT TRUE FALSE

%%

Program:	
	MainClass ClassDeclList /*RBRACE*/ {printf("wahoo\n");}
	;

MainClass:
	CLASS id LBRACE HEADER LPARENTH STRINGDECL LBRACK RBRACK id RPARENTH LBRACE StatementList RBRACE RBRACE
	;

ClassDeclList:
	ClassDecl ClassDeclList
	|/*empty*/
	;

ClassDecl:
	class id Parent ParentList LBRACE VarDeclList MethodDeclList RBRACE
	;

ParentList:
	|Parent ParentList
	;

Parent:
	LBRACE extends id RBRACE
	;
	

VarDeclList:
	|VarDecl VarDeclList
	;

VarDecl:
	WORD
	;

MethodDeclList:
	MethodDecl MethodDeclList
	| /*empty*/
	;

MethodDecl:
	WORD
	;

StatementList: 
	Statement StatementList
	| /*empty*/
	;

Statement:
	VarDecl
	| LBRACE StatementList RBRACE
	| IF LPARENTH Exp RPARENTH Statement
	| WHILE LPARENTH Exp RPARENTH Statement
	;

Exp:
	Exp op Exp
	| NOT Exp
	| PLUS Exp
	| MINUS Exp
	| LPARENTH Exp RPARENTH
	| STRING_LITERAL
	| TRUE
	| FALSE	
 
	;

id:
	WORD
	;

op:
	AND
	| OR
	| LESS
	| GREAT
	| LESSEQ
	| GREATEQ
	| EQUAL
	| NOTEQUAL
	| PLUS
	| MINUS
	| STAR
	| SLASH
	;

extends:
	EXTENDS
	;

class:
	WORD
	;
