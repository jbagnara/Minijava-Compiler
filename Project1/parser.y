%{
#include <stdio.h>
#include <string.h>

extern int yylineno;
extern FILE* yyin;
extern int yyparse();
extern int yylex();

void yyerror(const char* str){
	printf("Syntax errors found in line number %d\n", yylineno);
}

int yywrap(){
	return 1;
}

int main(int argc, char** argv){
	#ifdef YYDEBUG
	yydebug = 1;
	#endif
	char* fname = argv[1];
	FILE* file = fopen(argv[1], "r");
	yyin = file;
	yyparse();
	fclose(file);
}

%}


%token AND OR LESS GREAT LESSEQ GREATEQ EQUAL NOTEQUAL PLUS MINUS STAR SLASH LBRACK RBRACK LBRACE RBRACE LPARENTH RPARENTH EXTENDS HEADER STRING_LITERAL WORD CLASS IF WHILE NOT TRUE FALSE PRIMETYPE PUBLIC COMMA EQUIVALENT SEMICOLON PRINT PRINTLN DOT NEW THIS RETURN INTEGER_LITERAL LENGTH ELSE BRACKETS

%%

Program:	
	MainClass ClassDeclList /*RBRACE*/ {printf("wahoo\n");}
	;

MainClass:
	CLASS id LBRACE HEADER LPARENTH PRIMETYPE BRACKETS id RPARENTH LBRACE StatementList RBRACE RBRACE {printf("maintime\n");}
	;

ClassDeclList:
	ClassDecl ClassDeclList
	|/*empty*/
	;

ClassDecl:
	CLASS id ParentMaybe LBRACE VarMethodDeclList RBRACE
	;

ParentMaybe:
	Parent
	| /*empty*/	{printf("chungus\n");}	
	;

Parent:
	EXTENDS id
	;

VarMethodDeclList:
	VarOrMethod VarMethodDeclList
	| /*empty*/
	;

VarOrMethod:
	Type id VarMethodDecl
	| PUBLIC Type id MethodDecl
	;

VarMethodDecl:
	VarDecl
	| MethodDecl
	;

VarDecl:
	VarInitList SEMICOLON
	;

VarInitList:
	VarInit
	| VarInit COMMA id VarInitList
	;

VarInit:
	EQUAL Exp
	| /*empty*/
	;

MethodDecl:
	LPARENTH FormalListMaybe RPARENTH LBRACE StatementList RBRACE
	;

FormalListMaybe:
	FormalList
	| /*empty*/
	;

FormalList:
	Type id
	| Type id COMMA FormalList

Type:
	PRIMETYPE BracketsList		{printf("wowa\n");}
	| id BracketsList

BracketsList:
	BracketsList BRACKETS	{printf("yayayaa\n");}
	| /*empty*/ 
	;

StatementList: 
	Statement StatementList
	| /*empty*/
	;

Statement:
	Type id VarDecl
	| LBRACE StatementList RBRACE
	| IF LPARENTH Exp RPARENTH Statement ELSE Statement
	| WHILE LPARENTH Exp RPARENTH Statement
	| PRINTLN LPARENTH Exp RPARENTH SEMICOLON
	| PRINT LPARENTH Exp RPARENTH SEMICOLON
	| LeftValue EQUAL Exp SEMICOLON
	| LeftValue2 EQUAL Exp SEMICOLON
	| RETURN Exp SEMICOLON
	| MethodCall SEMICOLON
	;


MethodCall:
	LeftValue LPARENTH ExpList RPARENTH
	| LeftValue LPARENTH RPARENTH
	;

LeftValue:
	id	{printf("woah %d\n", yylineno);}
	| LeftValue LBRACK Index
	| LeftValue DOT id
	| NewFunc DOT id
	| THIS DOT id
	;

LeftValue2:	
	| LeftValue2 LBRACK Index
	| LeftValue2 DOT id
	| LPARENTH NewFunc RPARENTH DOT id

IndexList:
	IndexList LBRACK Index
	| Index

Index:
	Exp RBRACK
	;

ExpList:
	Exp
	| ExpList COMMA Exp
	;

ExpOp:
	NOT ExpOp
	| LPARENTH Exp RPARENTH
	| STRING_LITERAL
	| TRUE
	| FALSE
	| INTEGER_LITERAL
	| MethodCall
	| NewFunc
	| NEW Type LBRACK IndexList
	| LeftValue
	| LeftValue DOT LENGTH
	| PLUS ExpOp
	| MINUS ExpOp
	;

NewFunc:
	NEW id LPARENTH RPARENTH
	;

Exp:
	Exp op ExpOp
	| ExpOp
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
	| STAR
	| SLASH
	| PLUS
	| MINUS
	;
