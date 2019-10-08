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
		printf("%s\t%d\n", current->name, current->value);
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
%token<num> AND OR LESS GREAT LESSEQ GREATEQ EQUAL NOTEQUAL PLUS MINUS STAR SLASH LBRACK RBRACK LBRACE RBRACE LPARENTH RPARENTH EXTENDS HEADER STRING_LITERAL CLASS IF WHILE NOT TRUE FALSE PRIMETYPE PUBLIC COMMA EQUIVALENT SEMICOLON PRINT PRINTLN DOT NEW THIS RETURN LENGTH ELSE BRACKETS

%union{
	int num;
	char* str;
}

%token<str> WORD
%token<num> INTEGER_LITERAL

%type<str> LeftValue
%type<num> ExpOp Exp NewFunc MethodCall id VarInitList VarInit VarMethodDecl VarOrMethod MethodDecl VarDecl

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
	Type WORD VarMethodDecl		{if(search($2)==NULL){insert($2);} search($2)->value=$3;}	//adds first var to table
	| PUBLIC Type WORD MethodDecl	{if(search($3)==NULL){insert($3);} search($3)->value=$4;}

	;

VarMethodDecl:
	VarDecl					{$$ = $1;}
	| MethodDecl
	;

VarDecl:
	VarInitList SEMICOLON			{$$ = $1;}
	;

VarInitList:
	VarInit					{$$ = $1;}
	| VarInit COMMA WORD VarInitList	{$$ = $1; if(search($3)==NULL){insert($3);} search($3)->value = $4;}	//adds more vars to table
	;

VarInit:
	EQUAL Exp			{$$ = $2;}
	| /*empty*/			{$$ = 0;}	//dummy value
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
	Type WORD VarDecl			{if(search($2)==NULL){insert($2);} search($2)->value = $3;}
	| LBRACE StatementList RBRACE
	| IF LPARENTH Exp RPARENTH Statement ELSE Statement
	| WHILE LPARENTH Exp RPARENTH Statement
	| PRINTLN LPARENTH Exp RPARENTH SEMICOLON
	| PRINT LPARENTH Exp RPARENTH SEMICOLON
	| LeftValue EQUAL Exp SEMICOLON		{search($1)->value = $3;}
	| LeftValue2 EQUAL Exp SEMICOLON
	| RETURN Exp SEMICOLON
	| MethodCall SEMICOLON
	;


MethodCall:
	LeftValue LPARENTH ExpList RPARENTH
	| LeftValue LPARENTH RPARENTH
	;

LeftValue:
	WORD				{$$ = $1;}
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
	NOT ExpOp			{$$ = !$2;}
	| LPARENTH Exp RPARENTH		{$$ = $2;}
	| STRING_LITERAL
	| TRUE				{$$ = 1;}
	| FALSE				{$$ = 0;}
	| INTEGER_LITERAL		{$$ = $1;}
	| MethodCall
	| NewFunc
	| NEW Type LBRACK IndexList
	| LeftValue			{$$ = search($1)->value;}
	| LeftValue DOT LENGTH
	| PLUS ExpOp			{$$ = $2;}
	| MINUS ExpOp			{$$ = $2 * (-1);}
	;

NewFunc:
	NEW id LPARENTH RPARENTH
	;

Exp:
	Exp AND ExpOp			{$$ = $1 && $3;}
	| Exp OR ExpOp			{$$ = $1 || $3;}
	| Exp LESS ExpOp		{$$ = $1 < $3;}
	| Exp GREAT ExpOp		{$$ = $1 > $3;}
	| Exp LESSEQ ExpOp		{$$ = $1 <= $3;}
	| Exp GREATEQ ExpOp		{$$ = $1 >= $3;}
	| Exp EQUIVALENT ExpOp		{$$ = $1 == $3;}
	| Exp NOTEQUAL ExpOp		{$$ = $1 != $3;}
	| Exp STAR ExpOp		{$$ = $1 * $3;}
	| Exp SLASH ExpOp		{$$ = $1 / $3;}
	| Exp PLUS ExpOp		{$$ = $1 + $3;}
	| Exp MINUS ExpOp		{$$ = $1 - $3;}
	| ExpOp				{$$ = $1;}
	;

id:
	WORD{
		if(search($1)!=NULL){
			$$ = search($1)->value;
		} else{		//do something if not declared yet, idk what
		}
	}
	;

