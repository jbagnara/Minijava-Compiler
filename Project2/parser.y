%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

extern int yylineno;
extern FILE* yyin;
extern int yyparse();
extern int yylex();

typedef struct symbol {
	char name[50];
	//type
	int value;		//change later
	struct symbol* next;
} sym;

sym* head;
sym* tail;

void insert(char* name){
	tail->next = malloc(sizeof(sym));
	tail = tail->next;
	strcpy(tail->name, name);
	//tail->value = value;
}

sym* search(char* name){
	sym* current = head->next;
	while(current!=NULL){
		if(!strcmp(name, current->name)){
			return current;
		}
		current = current->next;	
	}
	return NULL;
}

void printall(){
	sym* current = head->next;
	while(current!=NULL){
		printf("%s\n", current->name);
		current = current->next;
	}
}

void yyerror(const char* str){
	printf("Syntax errors found in line number %d\n", yylineno);
}

int yywrap(){
	return 1;
}

int main(int argc, char** argv){
	head = malloc(sizeof(sym));	//init sym linkedlist
	tail = head;
	#ifdef YYDEBUG
	yydebug = 1;
	#endif
	char* fname = argv[1];
	FILE* file = fopen(argv[1], "r");
	yyin = file;
	yyparse();
	fclose(file);
	printall();
	
}

%}
%token<num> AND OR LESS GREAT LESSEQ GREATEQ EQUAL NOTEQUAL PLUS MINUS STAR SLASH LBRACK RBRACK LBRACE RBRACE LPARENTH RPARENTH EXTENDS HEADER STRING_LITERAL CLASS IF WHILE NOT TRUE FALSE PRIMETYPE PUBLIC COMMA EQUIVALENT SEMICOLON PRINT PRINTLN DOT NEW THIS RETURN INTEGER_LITERAL LENGTH ELSE BRACKETS

%union{
	int num;
	char* str;
}

%token<str> WORD

%type<str> id

%%

Program:	
	MainClass ClassDeclList
	;

MainClass:
	CLASS id LBRACE HEADER LPARENTH PRIMETYPE BRACKETS id RPARENTH LBRACE StatementList RBRACE RBRACE
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
	| /*empty*/
	;

Parent:
	EXTENDS id
	;

VarMethodDeclList:
	VarOrMethod VarMethodDeclList
	| /*empty*/
	;

VarOrMethod:
	Decl VarMethodDecl		//{insert($2);} //{printf("%s\n", &$2);}
	| PUBLIC Decl MethodDecl
	;

Decl:
	Type id {
			if(search($2)==NULL){	//checks if symbol is already in table
				insert($2);
			}
		}
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
	PRIMETYPE BracketsList
	| id BracketsList

BracketsList:
	BracketsList BRACKETS
	| /*empty*/ 
	;

StatementList: 
	Statement StatementList
	| /*empty*/
	;

Statement:
	Decl VarDecl
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
	id
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
	WORD		{$$ = $1;}
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
