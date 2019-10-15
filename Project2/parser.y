%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

extern int yylineno;
extern FILE* yyin;
extern int yyparse();
extern int yylex();

typedef enum varType{
	UNDEC = -1,
	STRING = 0,
	INT = 1
} varType;

typedef struct nonTerm {
	varType type;
	union value{
		char* str;
		int num;
	} value;
} nonTerm;

nonTerm* mkNonTerm(int type, void* val){
	nonTerm* term = malloc(sizeof(nonTerm));
	term->type = type;

	switch(type){
	case 0:
		term->value.str = (char*)val;
		break;
	case 1:
		term->value.num = *(int*)val;
		break;
	}

	return term;
}

typedef struct ast {
	int isLeaf;
	union node{
		char op;
		nonTerm* leaf;
	} node;
	struct ast* node1;
	struct ast* node2;
} ast;

ast* mkLeaf(nonTerm* leaf) {
	ast* tree = malloc(sizeof(ast));
	tree->isLeaf = 1;
	tree->node.leaf = leaf;
	return tree;
}

ast* mkNode(ast* node1, ast* node2, char op){
	ast* tree = malloc(sizeof(ast));
	if(op=='*' || op=='/'){
		ast* temp = node1;		//parent of rightmost leaf on left subtree
		while(temp->node2->node2!=NULL)
			temp = temp->node2;
		ast* temp2 = temp->node2;	//rightmost leaf on left subtree
		tree->isLeaf = 0;
		tree->node.op = op;
		temp->node2 = tree;
		tree->node1 = temp2;
		tree->node2 = node2;
		tree = temp;
	} else {
		tree->isLeaf = 0;
		tree->node.op = op;
		tree->node1 = node1;
		tree->node2 = node2;
	}
	return tree;
}

nonTerm* solveAst(ast* tree){

	if(tree->isLeaf){
		return tree->node.leaf;
	} else {
		int val1 = solveAst(tree->node1)->value.num;
		int val2 = solveAst(tree->node2)->value.num;
		int res;
		switch(tree->node.op){
		case '*':
			res = val1*val2;
			break;
		case '/':
			break;
		case '+':
			res = val1+val2;
			break;
		case '-':
			break;
		}
		return mkNonTerm(INT, &res);
	}
}

typedef struct symbol {
	char name[50];
	nonTerm* term;
	struct symbol* next;
} sym;

sym* head;
sym* tail;

void insert(varType type, char* name){
	tail->next = malloc(sizeof(sym));
	tail->next->term = malloc(sizeof(nonTerm));
	tail = tail->next;
	strcpy(tail->name, name);
	tail->term->type = type;
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
		//printf("%s\t%d\n", current->name, current->value);
		current = current->next;
	}
}

void typeViolation(){
	printf("Type Violation in Line %d\n", yylineno);
	exit(1);
}
	

void yyerror(const char* str){
	printf("Syntax errors found in line number %d\n", yylineno);
	while(head!=NULL){
		tail = head->next;
		free(head->term);
		free(head);
		head = tail;	
	}
}

int yywrap(){
	return 1;
}

void printExp(nonTerm* term, int nline){
	switch(term->type){
	case 0:		//String
		if(nline)
			printf("%s\n", term->value.str);
		else	
			printf("%s", term->value.str);
		break;
	case 1:		//int
		if(nline)
			printf("%d\n", term->value.num);
		else	
			printf("%d", term->value.num);
		break;
	
	}
}

varType setType(char* type){
	if(!(strcmp(type, "String"))){
		return 0;
	} else if(!(strcmp(type, "int"))){
		return 1;
	}
}



int main(int argc, char** argv){
	head = malloc(sizeof(sym));	//init sym linkedlist
	head->term = malloc(sizeof(nonTerm));
	tail = head;
	#ifdef YYDEBUG
	yydebug = 1;
	#endif
	char* fname = argv[1];
	FILE* file = fopen(argv[1], "r");
	if(argc>1 && file==NULL){
		printf("invalid filename\n");
		exit(1);
	}
	yyin = file;
	yyparse();
	//free(head->term);
	//free(head);
	if(argc>1)
		fclose(file);
	//printall();	
}

%}
%token<num> AND OR LESS GREAT LESSEQ GREATEQ EQUAL NOTEQUAL PLUS MINUS STAR SLASH LBRACK RBRACK LBRACE RBRACE LPARENTH RPARENTH EXTENDS HEADER CLASS IF WHILE NOT TRUE FALSE PUBLIC COMMA EQUIVALENT SEMICOLON PRINT PRINTLN DOT NEW THIS RETURN LENGTH ELSE BRACKETS

%code requires{
	typedef enum varTypeY{
		UNDECY = -1,
		STRINGY = 0,
		INTY = 1
	} varTypeY;
	typedef struct nonTermY {
		varTypeY type;
		union valueY{
			char* str;
			int num;
		} value;
	} nonTermY;
	typedef struct astY {
		int isLeaf;
		union nodeY{
			char op;
			nonTermY leaf;
		} node;
		struct astY* node1;
		struct astY* node2;
	} astY;
}

%union{
	int num;
	char* str;
	nonTermY term;
	varTypeY type;
	astY* tree;
}

%token<str> WORD STRING_LITERAL PRIMETYPE
%token<num> INTEGER_LITERAL

%type<str> LeftValue
%type<term> VarInit VarInitList NewFunc MethodCall id VarMethodDecl VarOrMethod MethodDecl VarDecl
%type<tree> Exp ExpOp
%type<type> Type


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
	Type WORD VarMethodDecl		{if(search($2)==NULL){insert((varType)$1, $2);} search($2)->term->value.num=$3.value.num;}	//adds first var to table
	| PUBLIC Type WORD MethodDecl	{if(search($3)==NULL){insert((varType)$2, $3);} search($3)->term->value.num=$4.value.num;}
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
	| VarInit COMMA WORD VarInitList	
		{$$ = $1; 
		if(search($3)==NULL) {
			insert(INT, $3);
		} 
		if(search($3)->term->type==$4.type)
			memcpy((void*)search($3)->term, (void*)&$4, sizeof(nonTerm));
		else if($4.type!=UNDECY)
			typeViolation();
	}	//adds more vars to table		CHANGE THIS
	;

VarInit:
	EQUAL Exp			{$$ = *(nonTermY*)solveAst((ast*)$2);}
	//| /*empty*/			{$$.type=UNDEC2;}	//dummy value
	;

MethodDecl:
	LPARENTH FormalListMaybe RPARENTH LBRACE StatementList RBRACE	{}
	;

FormalListMaybe:
	FormalList
	| /*empty*/
	;

FormalList:
	Type id
	| Type id COMMA FormalList

Type:
	PRIMETYPE BracketsList			{$$ = setType($1);}
	| id BracketsList			{}

BracketsList:
	BracketsList BRACKETS
	| /*empty*/ 
	;

StatementList: 
	Statement StatementList
	| /*empty*/
	;

Statement:
	Type WORD VarDecl			{
		if(search($2)==NULL){
			insert($1, $2);
		} 
		search($2)->term->value.num = $3.value.num;
	}
	| LBRACE StatementList RBRACE		
	| IF LPARENTH Exp RPARENTH Statement ELSE Statement
	| WHILE LPARENTH Exp RPARENTH Statement
	| PRINTLN LPARENTH Exp RPARENTH SEMICOLON		{
		printExp(solveAst((ast*)$3), 1);
	}
	| PRINT LPARENTH Exp RPARENTH SEMICOLON			{printExp((nonTerm*)&$3, 0);}
	| LeftValue EQUAL Exp SEMICOLON		{memcpy((void*)search($1)->term, (void*)&$3, sizeof(nonTerm));}
	| LeftValue2 EQUAL Exp SEMICOLON
	| RETURN Exp SEMICOLON
	| MethodCall SEMICOLON
	;


MethodCall:
	LeftValue LPARENTH ExpList RPARENTH			{}
	| LeftValue LPARENTH RPARENTH				{}
	;

LeftValue:
	WORD				{
		if(search($1)!=NULL)
			$$ = $1;
		else
			typeViolation();
	}
	| LeftValue LBRACK Index	{}
	| LeftValue DOT id		{}
	| NewFunc DOT id		{}
	| THIS DOT id			{}
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
	NOT ExpOp			{}//{$$ = !$2;}
	| LPARENTH Exp RPARENTH		{$$ = $2;}
	| STRING_LITERAL		{$$ = (astY*)mkLeaf(mkNonTerm(STRINGY, (void*)$1));}//{$$.value.str = $1; $$.type = STRING2;}
	| TRUE				{}//{$$ = 1;}
	| FALSE				{}//{$$ = 0;}
	| INTEGER_LITERAL		{$$ = (astY*)mkLeaf(mkNonTerm(INTY, (void*)&$1));}//{$$.value.num = $1; $$.type = INT2;}
	| MethodCall			{}
	| NewFunc			{}
	| NEW Type LBRACK IndexList	{}
	| LeftValue			{if(search($1)!=NULL){$$ = (astY*)mkLeaf((nonTerm*)search($1)->term);}}
	| LeftValue DOT LENGTH		{}
	//| PLUS ExpOp			{$$.value.num = $2.value.num;}
	//| MINUS ExpOp			{$$.value.num = $2.value.num * (-1);}
	;

NewFunc:
	NEW id LPARENTH RPARENTH	{}
	;

Exp:
	Exp AND ExpOp			//{$$ = $1 && $3;}
	| Exp OR ExpOp			//{$$ = $1 || $3;}
	| Exp LESS ExpOp		//{$$ = $1 < $3;}
	| Exp GREAT ExpOp		//{$$ = $1 > $3;}
	| Exp LESSEQ ExpOp		//{$$ = $1 <= $3;}
	| Exp GREATEQ ExpOp		//{$$ = $1 >= $3;}
	| Exp EQUIVALENT ExpOp		//{$$ = $1 == $3;}
	| Exp NOTEQUAL ExpOp		//{$$ = $1 != $3;}
	| Exp STAR ExpOp		{$$ = (astY*)mkNode((ast*)$1, (ast*)$3, '*');}
	//| Exp SLASH ExpOp		{$$.value.num = $1.value.num / $3.value.num;}
//{$$ = $1 / $3;}
	| Exp PLUS ExpOp		{$$ = (astY*)mkNode((ast*)$1, (ast*)$3, '+');}
//{$$ = $1 + $3;}
	//| Exp MINUS ExpOp		{$$.value.num = $1.value.num - $3.value.num;}
//{$$ = $1 - $3;}
	| ExpOp				{$$ = $1;}
//{$$ = $1;}
	;

id:
	WORD{
		if(search($1)!=NULL){
			memcpy((void*)&$$, (void*)search($1)->term, sizeof(nonTerm));
		} else{		//do something if not declared yet, idk what
		}
	}
	;

