%{
#include <stdio.h>
#include <string.h>

extern int yylineno;
extern FILE* yyin;

void yyerror(const char* str){
	printf("Syntax errors found in line number %d\n", yylineno);
}

int yywrap(){
	return 1;
}

main(int argc, char** argv){
	char* fname = argv[1];
	FILE* file = fopen(argv[1], "r");
	yyin = file;
	yyparse();
}

%}


%token AND OR LESS GREAT LESSEQ GREATEQ EQUAL NOTEQUAL PLUS MINUS STAR SLASH LBRACK RBRACK LBRACE RBRACE LPARENTH RPARENTH EXTENDS HEADER STRING_LITERAL WORD CLASS IF WHILE NOT TRUE FALSE PRIMETYPE PUBLIC COMMA EQUIVALENT SEMICOLON PRINT PRINTLN DOT NEW THIS RETURN INTEGER_LITERAL

%%

Program:	
	MainClass ClassDeclList /*RBRACE*/ {printf("wahoo\n");}
	;

MainClass:
	CLASS id LBRACE HEADER LPARENTH PRIMETYPE LBRACK RBRACK id RPARENTH LBRACE StatementList RBRACE RBRACE
	;

ClassDeclList:
	ClassDecl ClassDeclList
	|/*empty*/
	;

ClassDecl:
	CLASS id ParentMaybe LBRACE VarDeclList MethodDeclList RBRACE
	;

ParentMaybe:
	Parent
	| /*empty*/	

Parent:
	LBRACE EXTENDS id RBRACE
	;
	

VarDeclList:
	VarDecl VarDeclList
	| /*empty*/
	;

VarDecl:
	Type id VarInitList SEMICOLON
	| Type id SEMICOLON
	;

VarInitList:
	VarInit
	| VarInit COMMA VarInitList

VarInit:
	EQUAL Exp

MethodDeclList:
	MethodDecl MethodDeclList
	| /*empty*/
	;

MethodDecl:
	PUBLIC Type id LPARENTH FormalListMaybe RPARENTH StatementList
	| Type id LPARENTH FormalListMaybe RPARENTH StatementList
	;

FormalListMaybe:
	FormalList
	| /*empty*/
	;

FormalList:
	Type id LPARENTH
	| Type id LPARENTH COMMA FormalList

Type:
	PRIMETYPE
	| Type LBRACK RBRACK	{printf("yayayaa\n");}
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
	| PRINTLN LPARENTH Exp RPARENTH SEMICOLON
	| PRINT LPARENTH Exp RPARENTH SEMICOLON
	| LeftValue EQUAL Exp SEMICOLON
	| RETURN Exp SEMICOLON
	| MethodCall SEMICOLON
	;

MethodCall:
	LeftValue LPARENTH ExpList RPARENTH
	| LeftValue LPARENTH RPARENTH
	;

LeftValue:
	id
	| LeftValue Index
	| LeftValue DOT id
	| LPARENTH NEW id LPARENTH RPARENTH RPARENTH DOT id
	| NEW id LPARENTH RPARENTH DOT id
	| THIS DOT id
	;

Index:
	LBRACK Exp RBRACK
	| Index LBRACK Exp RBRACK

ExpList:
	Exp
	| Exp COMMA Exp
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
	| INTEGER_LITERAL
	| MethodCall

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
	| EQUIVALENT
	| NOTEQUAL
	| MINUS
	| STAR
	| SLASH
	;

class:
	WORD
	;
