%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

extern int yylineno;
extern FILE* yyin;
extern int yyparse();
extern int yylex();


void typeViolation(){
	printf("Type Violation in Line %d\n", yylineno);
	exit(1);
}

typedef enum varType{
	UNDEC	 = -1,
	STRING	 = 0,
	INT	 = 1,
	BOOL	 = 2
} varType;
typedef enum opType{
	ANDy		= 0,
	ORy		= 1,
	LESSy		= 2,
	GREATy		= 3,
	LESSEQy		= 4,
	GREATEQy	= 5,
	EQUIVALENTy	= 6,
	NOTEQUALy	= 7,
	EQUALy		= 8,
	NOTy		= 9,
	PLUSy		= 10,
	MINUSy		= 11,
	STARy		= 12,
	SLASHy		= 13
} opType;

typedef struct nonTerm {
	varType type;
	union value{
		char* str;
		int num;
	} value;
} nonTerm;

typedef struct nonTermArr {
	int length;
	varType type;
	nonTerm** term;
} nonTermArr;

nonTerm* mkNonTerm(int type, void* val){
	nonTerm* term = malloc(sizeof(nonTerm));
	term->type = type;

	switch(type){
	case STRING:
		term->value.str = (char*)val;
		break;
	case INT:
		term->value.num = *(int*)val;
		break;
	case BOOL:
		term->value.num = *(int*)val;
		break;
	}

	return term;
}

typedef struct ast {
	int isLeaf;
	union node{
		opType op;
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

ast* mkNode(ast* node1, ast* node2, opType op){
	ast* tree = malloc(sizeof(ast));
	tree->isLeaf = 0;
	tree->node.op = op;
	tree->node1 = node1;
	tree->node2 = node2;
	return tree;
}

void printAst(ast* tree){
	if(tree->isLeaf)
		printf("%d", tree->node.leaf->value.num);
	else{
		printf("%c", tree->node.op);
		printAst(tree->node1);
		printAst(tree->node2);
	}
}

nonTerm* solveAst(ast* tree){		//reduces ast tree to single nonTerm

	if(tree->isLeaf){
		return tree->node.leaf;
	} else {
		nonTerm* term1 = solveAst(tree->node1);
		nonTerm* term2 = solveAst(tree->node2);
		if(term1->type!=term2->type)
			typeViolation();
	
		switch(term1->type){
		case INT:{
			int val1 = term1->value.num;
			int val2 = term2->value.num;
			int res;
			switch(tree->node.op){
			case STARy:
				res = val1*val2;
				return mkNonTerm(INT, &res);
				break;
			case SLASHy:
				res = val1/val2;
				return mkNonTerm(INT, &res);
				break;
			case PLUSy:
				res = val1+val2;
				return mkNonTerm(INT, &res);
				break;
			case MINUSy:
				res = val1-val2;
				return mkNonTerm(INT, &res);
				break;
			case LESSy:
				res = val1<val2;
				return mkNonTerm(BOOL, &res);
				break;
			case GREATy:
				res = val1>val2;
				return mkNonTerm(BOOL, &res);
				break;
			case LESSEQy:
				res = val1<=val2;
				return mkNonTerm(BOOL, &res);
				break;
			case GREATEQy:
				res = val1>=val2;
				return mkNonTerm(BOOL, &res);
				break;
			case EQUIVALENTy:
				res = val1==val2;
				return mkNonTerm(BOOL, &res);
				break;
			case NOTEQUALy:
				res = val1!=val2;
				return mkNonTerm(BOOL, &res);
				break;
			default:
				printf("invalid int operation %d\n", term1->type );
				typeViolation();
			}
		break;
		}
		case BOOL:{
			int val1 = term1->value.num;
			int val2 = term2->value.num;
			int res;
			switch(tree->node.op){
			case EQUIVALENTy:
				res = val1==val2;
				return mkNonTerm(BOOL, &res);
				break;
			case NOTEQUALy:
				res = val1!=val2;
				return mkNonTerm(BOOL, &res);
				break;
			case ANDy:
				res = val1&&val2;
				return mkNonTerm(BOOL, &res);
				break;
			case ORy:
				res = val1||val2;
				return mkNonTerm(BOOL, &res);
				break;
			default:
				printf("invalid bool operation %d\n", term1->type );
				typeViolation();
			}
		break;
		}
		default:
			printf("type %d not implemented in ast\n", term1->type);
			typeViolation();
		}
	}
}

typedef struct symbol {
	char* name;
	nonTerm* term;
	struct symbol* next;
} sym;

sym* head;
sym* tail;

void insert(varType type, char* name){
	tail->next = malloc(sizeof(sym));
	tail->next->term = malloc(sizeof(nonTerm));
	tail = tail->next;
	tail->name = strdup(name);
	//strcpy(tail->name, name);
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
		printf("%s  %d\n", current->name, current->term->value.num);
		current = current->next;
	}
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
	case STRING:		//String
		if(nline)
			printf("%s\n", term->value.str);
		else	
			printf("%s", term->value.str);
		break;
	case INT:		//int
		if(nline)
			printf("%d\n", term->value.num);
		else	
			printf("%d", term->value.num);
		break;
	case BOOL:
		if(nline)
			printf("%d\n", term->value.num);
		else	
			printf("%d", term->value.num);
		break;	
	}
}

varType setType(char* type){
	if(!(strcmp(type, "String"))){
		return STRING;
	} else if(!(strcmp(type, "int"))){
		return INT;
	} else if(!(strcmp(type, "boolean"))){
		return BOOL;
	} else{
		printf("usermade types not implemented yet\n");
		typeViolation();
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
		UNDECY 	= -1,
		STRINGY = 0,
		INTY 	= 1,
		BOOLY	= 2
	} varTypeY;
	typedef enum opTypeY{
		ANDY		= 0,
		ORY		= 1,
		LESSY		= 2,
		GREATY		= 3,
		LESSEQY		= 4,
		GREATEQY	= 5,
		EQUIVALENTY	= 6,
		NOTEQUALY	= 7,
		EQUALY		= 8,
		NOTY		= 9,
		PLUSY		= 10,
		MINUSY		= 11,
		STARY		= 12,
		SLASHY		= 13
	} opTypeY;

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
			opTypeY op;
			nonTermY* leaf;
		} node;
		struct astY* node1;
		struct astY* node2;
	} astY;

	typedef struct symbolY {
		char* name;
		nonTermY* term;
		struct symbolY* next;
	} symY;
}

%union{
	int num;
	char* str;
	nonTermY term;
	varTypeY type;
	astY* tree;
	symY* termList;
}

%token<str> WORD STRING_LITERAL PRIMETYPE
%token<num> INTEGER_LITERAL

%type<str> LeftValue
%type<term> NewFunc MethodCall id VarOrMethod
%type<termList> VarInitList VarMethodDecl MethodDecl VarDecl VarInit
%type<tree> Exp ExpP ExpP2 ExpOp 
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
	Type WORD VarMethodDecl		{			//DO INSERTIONS HERE***
		symY* head = $3;
		head->name = $2;
		while(head!=NULL){
			if(search(head->name)==NULL){	//Does not exist in sym table
				if(head->term==NULL){	//Declared but not initialized
					insert((varType)$1, head->name);
				} else{
					if(head->term->type!=$1){
						typeViolation();		//Different types
					}
					insert((varType)$1, head->name);
					search(head->name)->term = (nonTerm*)head->term;
				}
			} else {
				typeViolation();		//Already declared
			}
			head = (symY*)head->next;
		}

		//search($2)->term->value.num=$3.value.num;
	}	//adds first var to table
	| PUBLIC Type WORD MethodDecl	{
		symY* head = $4;
		head->name = $3;
		while(head!=NULL){
			if(search(head->name)==NULL){	//Does not exist in sym table
				insert((varType)$1, head->name);
				search(head->name)->term = (nonTerm*)head->term;
			} else {
				typeViolation();
			}
		}

		if(search($3)==NULL){
			insert((varType)$2, $3);
		} 
	}
	;

VarMethodDecl:
	VarDecl					{$$ = $1;}
	| MethodDecl
	;

VarDecl:
	VarInitList SEMICOLON			{$$ = $1;}
	;

VarInitList:
	VarInit	/*First does not have name yet*/{
		/*symY* var = malloc(sizeof(symY));
		var->term = &$1;
		$$ = var;*/
		$$ = $1;
	}
	| VarInit COMMA WORD VarInitList	{
		$4->name = $3;
		$1->next = $4;
		$$ = $1;
	}	//adds more vars to table		CHANGE THIS
	;

VarInit:
	EQUAL ExpP			{
		//$$ = *(nonTermY*)solveAst((ast*)$2);
		symY* var = malloc(sizeof(symY));
		var->term = (nonTermY*)solveAst((ast*)$2);
		$$ = var;
	}
	| /*empty*/			{
		symY* var = malloc(sizeof(symY));
		$$ = var;
	}	//dummy value
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
		symY* head = $3;
		head->name = $2;
		while(head!=NULL){
			if(search(head->name)==NULL){	//Does not exist in sym table
				if(head->term==NULL){	//Declared but not initialized
					insert((varType)$1, head->name);
				} else{
					if(head->term->type!=$1){
						typeViolation();		//Different types
					}
					insert((varType)$1, head->name);
					search(head->name)->term = (nonTerm*)head->term;
				}
			} else {
				typeViolation();		//Already declared
			}
			head = (symY*)head->next;
		}

		//search($2)->term->value.num=$3.value.num;
	}	//adds first var to table
	| LBRACE StatementList RBRACE		
	| IF LPARENTH Exp RPARENTH Statement ELSE Statement
	| WHILE LPARENTH Exp RPARENTH Statement
	| PRINTLN LPARENTH Exp RPARENTH SEMICOLON		{
		printExp(solveAst((ast*)$3), 1);
	}
	| PRINT LPARENTH Exp RPARENTH SEMICOLON			{printExp((nonTerm*)&$3, 0);}
	| LeftValue EQUAL Exp SEMICOLON		{
		astY* x =$3;
		char* y = $1;
		search($1)->term = solveAst((ast*)$3);
		//printall();
		//memcpy((void*)search($1)->term, (void*)(solveAst((ast*)$3)), sizeof(nonTerm));
	}
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
	| STRING_LITERAL {
		$$ = (astY*)mkLeaf(mkNonTerm(STRINGY, (void*)$1));
	}
	| TRUE {
		$$ = (astY*)mkLeaf(mkNonTerm(BOOLY, (void*)&$1));
	}
	| FALSE	{
		$$ = (astY*)mkLeaf(mkNonTerm(BOOLY, (void*)&$1));
	}
	| INTEGER_LITERAL {
		$$ = (astY*)mkLeaf(mkNonTerm(INTY, (void*)&$1));
	}
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

ExpP2: 
	ExpP2 AND ExpOp			{$$ = (astY*)mkNode((ast*)$1, (ast*)$3, ANDY);}
	| ExpP2 OR ExpOp		{$$ = (astY*)mkNode((ast*)$1, (ast*)$3, ORY);}
	| ExpP2 LESS ExpOp		{$$ = (astY*)mkNode((ast*)$1, (ast*)$3, LESSY);}
	| ExpP2 GREAT ExpOp		{$$ = (astY*)mkNode((ast*)$1, (ast*)$3, GREATY);}	
	| ExpP2 LESSEQ ExpOp		{$$ = (astY*)mkNode((ast*)$1, (ast*)$3, LESSEQY);}	
	| ExpP2 GREATEQ ExpOp		{$$ = (astY*)mkNode((ast*)$1, (ast*)$3, GREATEQY);}	
	| ExpP2 EQUIVALENT ExpOp	{$$ = (astY*)mkNode((ast*)$1, (ast*)$3, EQUIVALENTY);}
	| ExpP2 NOTEQUAL ExpOp		{$$ = (astY*)mkNode((ast*)$1, (ast*)$3, NOTEQUALY);}
	| ExpOp				{$$ = $1;}
	;

ExpP:
	ExpP STAR ExpP2			{$$ = (astY*)mkNode((ast*)$1, (ast*)$3, STARY);}
	| ExpP SLASH ExpP2		{$$ = (astY*)mkNode((ast*)$1, (ast*)$3, SLASHY);}
	| ExpP2				{$$ = $1;}
	;

Exp:
	//| Exp SLASH ExpOp		{$$.value.num = $1.value.num / $3.value.num;}
//{$$ = $1 / $3;}
	Exp PLUS ExpP			{$$ = (astY*)mkNode((ast*)$1, (ast*)$3, PLUSY);}
//{$$ = $1 + $3;}
	| Exp MINUS ExpP		{$$ = (astY*)mkNode((ast*)$1, (ast*)$3, MINUSY);}
//{$$ = $1 - $3;}
	| ExpP				{$$ = $1;}
	;

id:
	WORD{
		if(search($1)!=NULL){
			memcpy((void*)&$$, (void*)search($1)->term, sizeof(nonTerm));
		} else{		//do something if not declared yet, idk what
		}
	}
	;

