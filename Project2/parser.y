%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

extern int yylineno;
extern FILE* yyin;
extern int yyparse();
extern int yylex();


struct nonTerm;
struct ast;
struct nonTerm* solveAst(struct ast*);
struct numLinkList;


void typeViolation(){
	printf("Type Violation in Line %d\n", yylineno);
	exit(1);
}

typedef enum varType{
	UNDEC		= -1,
	STRING		= 0,
	INT		= 1,
	BOOL		= 2,
	ARR	 	= 3,
	ARRUNDEC	= 4
} varType;

typedef struct arrType{
	varType type;
	int deg;
} arrType;

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
	arrType* arrType;
	int deg;
	union value{
		char* str;
		int num;
		struct nonTerm** arr;	
		struct numLinkList* numArr;
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
	term->deg = 1;
	if(val==NULL){
		term->value.str=NULL;
	} else {
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
		case ARR:
			term->value.arr = calloc(*(int*)val, sizeof(nonTerm));
			term->deg = *(int*)val;
			break;
		case ARRUNDEC:
			term->value.numArr = val;
			break;
		}
	}
	return term;
}



struct strArr;

typedef struct ast {
	int isLeaf;
	int isVar;
	struct strArr* str;
	union node{
		opType op;
		nonTerm* leaf;
	} node;
	struct ast* node1;
	struct ast* node2;
} ast;


typedef struct numLinkList{
	ast* num;
	struct numLinkList* next;
} numLinkList;

typedef struct strArr {
	char* str;
	numLinkList* num;
} strArr;

nonTerm* searchNonTermArr(nonTerm* arr, numLinkList* num){
	if(num==NULL)
		return arr;
	if(num->next==NULL){
		return arr->value.arr[solveAst(num->num)->value.num];
	}
	return searchNonTermArr(arr->value.arr[solveAst(num->num)->value.num], num->next);
}

nonTerm* mkNonTermArr(int type, numLinkList* list){	//builds array given dimensions
	if(list == NULL){
		return mkNonTerm(type, NULL);		//leaf
	}

	nonTerm* arr = mkNonTerm(ARR, list->num);
	for(int x=0; x<solveAst(list->num)->value.num; x++){
		arr->value.arr[x] = mkNonTermArr(type, list->next);
	}
	return arr;
}

ast* mkLeaf(nonTerm* leaf) {
	ast* tree = malloc(sizeof(ast));
	tree->isLeaf = 1;
	tree->isVar = 0;
	tree->node.leaf = leaf;
	return tree;
}


ast* mkLeafStr(strArr* str){
	ast* tree = malloc(sizeof(ast));
	tree->isLeaf = 1;
	tree->isVar = 1;
	//tree->str = malloc(sizeof(strArr));
	tree->str = str;
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



typedef struct symbol {
	char* name;
	nonTerm* term;
	struct symbol* next;
} sym;

sym* head;
sym* tail;

typedef struct symStack {
	sym* table;
	sym* tableTail;
	struct symStack* next;
	struct symStack* prev;
} symStack;

symStack* table;

symStack* pushTable(){				//pushes new symbol table
	symStack* thisTable = malloc(sizeof(symStack));

	thisTable->table = malloc(sizeof(sym));	//init sym linkedlist
	thisTable->table->term = malloc(sizeof(nonTerm));
	thisTable->tableTail = thisTable->table;

	head = thisTable->table;
	tail = thisTable->tableTail;
}

void popTable(){
	table = table->prev;			//there should always be parent table
	head = table->table;
	tail = table->tableTail;
	
	//need to free
}

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

typedef enum cmd {
	DECL 		= 0,
	IFELSE 		= 1,
	PRINTNLINE	= 2,
	PRINTN		= 3,
	INIT 		= 4,
	INIT2		= 5,
	WHILEN		= 6
} cmd;

typedef struct statement {
	cmd command;
	char* word1;
	ast* conditional;
	struct statement* sub1;
	struct statement* sub2;
	//sym* leftVal;
	strArr* leftVal;
	ast* exp;
	arrType* type;
	sym* varDecl;
	struct statement* next;
} statement;


statement* mkStatement(cmd command, ast* conditional, char* word1, strArr* leftVal, ast* exp, arrType* type, sym* varDecl){
	statement* exec = malloc(sizeof(statement));
	exec->command = command;
	exec->exp = conditional;
	exec->word1 = word1;
	exec->leftVal = leftVal;
	exec->exp = exp;
	exec->type = type;
	exec->varDecl = varDecl;
	exec->next = NULL;
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
	case ARR:
		printf("uhh\n");
		typeViolation();	
	}
}

nonTerm* solveAst(ast* tree){		//reduces ast tree to single nonTerm
	if(tree->isLeaf){
		if (tree->isVar){	//var
			tree->node.leaf =  search(tree->str->str)->term;
			if(tree->node.leaf->type==ARR){	//arr
				tree->node.leaf=searchNonTermArr(search(tree->str->str)->term, tree->str->num); 
			}
		}
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
		case ARR:
			return mkNonTerm(ARR, tree->node.leaf);
		default:
			printf("type %d not implemented in ast\n", term1->type);
			typeViolation();
		}
	}
}
void execStatement(statement* statem){
	switch(statem->command){
	case DECL:{	
		sym* head = statem->varDecl;
		head->name = statem->word1;
		arrType* thisType = statem->type;
		while(head!=NULL){
			if(search(head->name)==NULL){	//Does not exist in sym table
				if(head->term==NULL){	//Declared but not initialized
					insert(thisType->type, head->name);
				} else{
					if(head->term->type!=thisType->type){		//Different type
						if(thisType->deg>1){	//Is ARR, need to check type

							//uhh let's skip the check for now

						} else {
							printf("Incompatible types\n");
							typeViolation();		
						} 
					}
					insert(thisType->type, head->name);
					if(head->term->arrType!=NULL)	//solves for var indexes
						head->term = mkNonTermArr(head->term->arrType->type, head->term->value.numArr);
					
					search(head->name)->term = head->term;
				}
			} else {
				typeViolation();		//Already declared
			}
			head = head->next;
		}
		break;
	}
	case PRINTNLINE:{
		printExp(solveAst(statem->exp), 1);
		break;		
	}
	case PRINTN:
		printExp(solveAst(statem->exp), 0);
		break;		
	case INIT:{		
		sym* head = search(statem->leftVal->str);
		if(head->term->arrType!=NULL)				//solves for var indexes
			head->term = mkNonTermArr(head->term->arrType->type, head->term->value.numArr);
					

		memcpy((void*)searchNonTermArr(search(head->name)->term, statem->leftVal->num), (void*)solveAst(statem->exp), sizeof(nonTerm));			//copies exp to the symbol table pointer

		break;
	}
	case WHILEN:{
		while(solveAst(statem->conditional)->value.num)
			execStatement(statem->sub1);
		break;
	}
	case IFELSE:{
		if(solveAst(statem->conditional)->value.num)
			execStatement(statem->sub1);
		else
			execStatement(statem->sub2);
		break;
	}
	default:
		printf("something bad happened %d\n", statem->command);
		typeViolation();
	}
	if(statem->next!=NULL)
		execStatement(statem->next);

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
	table = pushTable();	//pushes main class symbol table to stack
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

	struct numLinkListY;

	typedef enum varTypeY{
		UNDECY 		= -1,
		STRINGY 	= 0,
		INTY 		= 1,
		BOOLY		= 2,
		ARRY		= 3,
		ARRUNDECY	= 4
	} varTypeY;

	typedef struct arrTypeY{
		varTypeY type;
		int deg;
	} arrTypeY;

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
		arrTypeY* arrType;
		int degY;
		union valueY{
			char* str;
			int num;
			struct nonTerm** arr;	
			struct numLinkListY* numArr;
		} value;
	} nonTermY;

	typedef struct nonTermArrY {
		int length;
		varTypeY type;
		nonTermY** term;
	} nonTermArrY;

	struct strArrY;

	typedef struct astY {
		int isLeaf;
		int isVar;
		struct strArrY* str;
		union nodeY{
			opTypeY op;
			nonTermY* leaf;
		} node;
		struct astY* node1;
		struct astY* node2;
	} astY;

	typedef struct numLinkListY{
		astY* num;
		struct numLinkListY* next;
	} numLinkListY;

	typedef struct strArrY {
		char* str;
		numLinkListY* num;
	} strArrY;

	typedef struct symbolY {
		char* name;
		nonTermY* term;
		struct symbolY* next;
	} symY;

	typedef enum cmdY {
		DECLY 		= 0,
		IFELSEY 	= 1,
		PRINTNLINEY	= 2,
		PRINTNY		= 3,
		INITY 		= 4,
		INIT2Y		= 5,
		WHILENY		= 6,
		LIST		= 7
	} cmdY;

	typedef struct statementY {
		cmdY command;
		astY* conditional;
		struct statement* sub1; 
		struct statement* sub2;
		char* word1;
		symY* leftVal;
		astY* exp;
		arrTypeY* type;
		symY* varDecl;
		struct statementY* next;
	} statementY;

}

%union{
	int num;
	numLinkListY* numList;
	char* str;
	nonTermY term;
	arrTypeY* type;
	astY* tree;
	symY* termList;
	statementY* statem;
	strArrY* strarr;
}

%token<str> WORD STRING_LITERAL PRIMETYPE
%token<num> INTEGER_LITERAL
%type<strarr> LeftValue LeftValue2
%type<num> BracketsList 
%type<numList> IndexList
%type<term> NewFunc MethodCall id VarOrMethod
%type<termList> VarInitList VarMethodDecl MethodDecl VarDecl VarInit //LeftValue LeftValue2
%type<tree> Exp ExpP ExpP2 ExpOp Index
%type<type> Type
%type<statem> Statement StatementList


%%

Program:	
	MainClass ClassDeclList
	;

MainClass:
	CLASS id LBRACE HEADER LPARENTH PRIMETYPE BRACKETS id RPARENTH LBRACE StatementList RBRACE RBRACE {
		execStatement((statement*)$11);
	}
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
	}
	| PUBLIC Type WORD MethodDecl	{
	 
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
	EQUAL Exp {
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
	LPARENTH FormalListMaybe RPARENTH LBRACE StatementList RBRACE	{
	}
	;

FormalListMaybe:
	FormalList
	| /*empty*/
	;

FormalList:
	Type id
	| Type id COMMA FormalList

Type:
	PRIMETYPE BracketsList			{
		$$ = malloc(sizeof(arrTypeY));
		$$->type = setType($1);
		$$->deg = $2;
	}
	| id BracketsList			{}

BracketsList:
	BracketsList BRACKETS			{$$++;} 
	| /*empty*/ 				{$$ = 1;}
	;

StatementList: 
	Statement StatementList  {
		//execStatement((statement*)$2);
		$1->next = $2;
		$$ = $1;	
	}
	| /*empty*/ {
		$$ = NULL;	//this needs to be here
	}
	;

Statement:
	Type WORD VarDecl {
		statement* statem = mkStatement(DECLY, NULL, $2, NULL, NULL, (arrType*)$1, (sym*)$3);
		$$ = (statementY*)statem;
	}	//adds first var to table
	| LBRACE StatementList RBRACE {
		$$ = $2;
	}	
	| IF LPARENTH Exp RPARENTH Statement ELSE Statement {
		statement* statem = mkStatement(IFELSEY, NULL, NULL, NULL, NULL, NULL, NULL);
		statem->conditional = (ast*)$3;
		statem->sub1 = (statement*)$5;
		statem->sub2 = (statement*)$7;
		$$ = (statementY*)statem;		
	}
	| WHILE LPARENTH Exp RPARENTH Statement {	//This guy adds an extra null statement that gets checked
		statement* statem = mkStatement(WHILENY, NULL, NULL, NULL, NULL, NULL, NULL);		
		statem->conditional = (ast*)$3;
		statem->sub1 = (statement*)$5;
		$$ = (statementY*)statem;
		
	}
	| PRINTLN LPARENTH Exp RPARENTH SEMICOLON {
		statement* statem = mkStatement(PRINTNLINE, NULL, NULL, NULL, (ast*)$3, NULL, NULL);
		$$ = (statementY*)statem;
	}
	| PRINT LPARENTH Exp RPARENTH SEMICOLON {
		statement* statem = mkStatement(PRINTN, NULL, NULL, NULL, (ast*)$3, NULL, NULL);
		$$ = (statementY*)statem;
	}
	| LeftValue EQUAL Exp SEMICOLON		{
		//$1->term = (nonTermY*)solveAst((ast*)$3);
		statement* statem = mkStatement(INIT, NULL, NULL, (strArr*)$1, (ast*)$3, NULL, NULL);
		$$ = (statementY*)statem;
		//memcpy((void*)$1->term, (void*)(solveAst((ast*)$3)), sizeof(nonTerm));	//lol
	}
	| LeftValue2 EQUAL Exp SEMICOLON {
		statement* statem = mkStatement(INIT, NULL, NULL, (strArr*)$1, (ast*)$3, NULL, NULL);
		$$ = (statementY*)statem;
	}
	| RETURN Exp SEMICOLON {}
	| MethodCall SEMICOLON {}
	;


MethodCall:
	LeftValue LPARENTH ExpList RPARENTH			{}
	| LeftValue LPARENTH RPARENTH				{}
	;

LeftValue:
	WORD				{
		//if(search($1)!=NULL)
			strArrY* this = malloc(sizeof(strArrY));
			this->str = $1;
			$$ = this;
			//$$ = (symY *)search($1);
		//else
		//	typeViolation();
	}
	| LeftValue LBRACK Index 	{
		if($1->num == NULL){		//first deg of array
			$1->num = malloc(sizeof(numLinkListY));
			$1->num->num = $3;
		} else {

		numLinkListY* current = $1->num;
		while(current->next!=NULL)
			current = current->next;	//points to tail

		current->next = malloc(sizeof(numLinkListY));
		current->next->num = $3;
	
		}
		$$ = $1;
	}
	| LeftValue DOT id		{}
	| NewFunc DOT id		{}
	| THIS DOT id			{}
	;

LeftValue2:	
	LeftValue2 LBRACK Index
	| LeftValue2 DOT id
	| LPARENTH NewFunc RPARENTH DOT id
	;

IndexList:				//returns list of ints to define array
	Index LBRACK IndexList {
		$$ = malloc(sizeof(numLinkListY));
		$$->num = $1;
		$$->next = $3;	
	}
	| Index {
		$$ = malloc(sizeof(numLinkListY));
		$$->num = $1;
	}

Index:
	Exp RBRACK {
		$$ = $1;
	}
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
	| NEW Type LBRACK IndexList	{		//CREATE ENTIRE ARRAY USING LIST OF INT
		//$$ = (astY*)mkLeaf((nonTerm*) mkNonTermArr((varType)$2->type, (numLinkList*)$4));	//***	
		$$ = (astY*)mkLeaf((nonTerm*)mkNonTerm(ARRUNDECY, (numLinkList*)$4));
		$$->node.leaf->arrType = $2;

	}
	| LeftValue			{
		if($1!=NULL){$$ = (astY*)mkLeafStr((strArr*)$1);}
	}
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

