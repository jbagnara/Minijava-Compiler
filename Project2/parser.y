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
struct astList;
struct strArr;
struct statement;


void typeViolation(int lineno){
	printf("Type Violation in Line %d\n", lineno);
	exit(1);
}

typedef enum varType{			//variable types
	UNDEC		= -1,
	STRING		= 0,
	INT		= 1,
	BOOL		= 2,
	ARR	 	= 3,
	ARRUNDEC	= 4,
	CLASSy		= 5
} varType;

typedef struct arrType{			//extension of varType for arrays
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

typedef struct nonTerm {		//nonterminals, stores unformated symbol table entry
	varType type;
	arrType* arrType;
	int deg;
	union value{
		char* str;
		int num;
		struct nonTerm** arr;	
		struct astList* numArr;
		struct classRef* class;
	} value;
} nonTerm;

typedef struct nonTermArr {		//extension of nonTerm for arrays
	int length;
	varType type;
	nonTerm** term;
} nonTermArr;

typedef struct ast {			//stores a subtree to be solved at execution
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

typedef struct astList{		//linked list of array size information
	ast* num;
	struct astList* next;
} astList;

typedef struct classLinkList{
	char* name;
	astList* exp;
	struct classLinkList* next;
} classLinkList;

typedef struct classRef {
	char* name;
	union sub{
		struct statement* list;	//method of class
		nonTerm* var;		//variable or subclass of class
	} sub;
} classRef;

typedef struct strArr {			//stores array variable
	char* str;
	astList* num;
	classLinkList* class;
} strArr;

typedef struct symbol {			//entry to symbol table
	char* name;
	nonTerm* term;
	struct symbol* next;
	ast* tree;
} sym;

typedef struct symStack {		//symbol table stack for accessing classes
	sym* table;
	sym* tableTail;
	struct symStack* next;
	struct symStack* prev;
} symStack;

typedef struct argList {
} argList;

typedef struct methodList {
	char* name;
	arrType* type;
	sym* arg;
	struct statement* statementList;
	struct methodList* next;
} methodList;

typedef struct varMethodList {
	sym* table;
	methodList* methods;
} varMethodList;

typedef struct classEntry {
	char* name;
	varMethodList* list;
} classEntry;

typedef struct classList {
	classEntry* class;
	struct classList* next;	
} classList;

typedef enum cmd {
	DECL 		= 0,
	IFELSE 		= 1,
	PRINTNLINE	= 2,
	PRINTN		= 3,
	INIT 		= 4,
	INIT2		= 5,
	WHILEN		= 6,
	RET		= 7
} cmd;

typedef struct statement {		//Executable command list
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
	int lineno;
} statement;



sym* head;		//head of current symbol table
sym* tail;
symStack* table;	//symbol table stack
statement* temp;
classList* classes;
classList* classesTail;
int line = 0;

nonTerm* execStatement(statement*);

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
		case CLASSy:
			term->value.class = malloc(sizeof(classRef));
			term->value.class->name = (char*)val;
		}
	}
	return term;
}

nonTerm* searchNonTermArr(nonTerm* arr, astList* num){
	if(num==NULL)
		return arr;
	if(num->next==NULL){
		return arr->value.arr[solveAst(num->num)->value.num];
	}
	return searchNonTermArr(arr->value.arr[solveAst(num->num)->value.num], num->next);
}

nonTerm* mkNonTermArr(int type, astList* list){	//builds array given dimensions
	if(list == NULL){
		return mkNonTerm(type, NULL);		//leaf
	}

	nonTerm* arr = mkNonTerm(ARR, &solveAst(list->num)->value.num);
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

void pushTable(){				//pushes new symbol table
	symStack* thisTable = malloc(sizeof(symStack));


	thisTable->table = malloc(sizeof(sym));	//init sym linkedlist
	thisTable->table->term = malloc(sizeof(nonTerm));
	thisTable->tableTail = thisTable->table;

	if(table==NULL){
		table = thisTable;
	} else{ 
		thisTable->prev = table;
		table->next = thisTable;
		table = table->next;
	}
	head = table->table;
	tail = table->tableTail;
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

void classInsert(classEntry* class){
	classesTail->next = malloc(sizeof(classList));
	classesTail->next->class = (classEntry*)class;
	classesTail = classesTail->next;	
}

classEntry* classSearch(char* name){
	classList* current = classes->next;
	while(current!=NULL){
		if(!strcmp(name, current->class->name)){
			return current->class;
		}
		current = current->next;	
	}
	return NULL;	
}

methodList* methodSearch(char* className, char* methodName){
	classEntry* class = classSearch(className);
	if(class==NULL)	//class not found
		typeViolation(line);

	methodList* current = class->list->methods;
	while(current!=NULL){
		if(!strcmp(methodName, current->name))
			return current;
		current = current->next;
	}
	return NULL;
	
}

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
	exec->lineno = yylineno;
}

statement* initArgs(sym* list, sym* input){			//do type checks! ***
	statement* current = NULL;
	statement* stateHead = current;
	sym* itr = list;
	while(itr!=NULL) {
		if(current==NULL){
			current = mkStatement(DECL, NULL, itr->name,  NULL, NULL, itr->term->arrType, itr);
			stateHead = current;
		}
		else{
			current->next = mkStatement(DECL, NULL, itr->name,  NULL, NULL, itr->term->arrType, itr);
			current = current->next;
		}
		itr = itr->next;
	}
	itr = list;
	while(input!=NULL){	
		strArr* this = malloc(sizeof(strArr));
		this->str = itr->name;
		current->next = mkStatement(INIT, NULL, NULL, this, mkLeaf(input->term), NULL, NULL);
		current = current->next;
		input = input->next;
		itr = itr->next;
	}
	return stateHead;

	//statement* statem = mkStatement(DECLY, NULL, $2, NULL, NULL, (arrType*)$1, (sym*)$3);
	//statement* statem = mkStatement(INIT, NULL, NULL, (strArr*)$1, (ast*)$3, NULL, NULL);
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
		typeViolation(line);	
	}
}

nonTerm* solveAst(ast* tree){		//reduces ast tree to single nonTerm
	if(tree->isLeaf){
		if (tree->isVar){	//var
			if(tree->str->class!=NULL){		//class shenanigans
				//gotta convert input to terms with solveAst!!
				methodList* method = methodSearch(tree->str->str, tree->str->class->name);
				statement* statementList = method->statementList;
				astList* input = tree->str->class->exp;
				sym* formInput = malloc(sizeof(sym));
				sym* formhead = formInput;
				while(input!=NULL){
					formInput->term = solveAst(input->num);
					formInput = formInput->next;
					formInput = malloc(sizeof(sym));
					input = input->next;
				}	
				statement* init = NULL;
				if(method->arg!=NULL&&formhead!=NULL)
					init = initArgs(method->arg, formhead);	//input declarations

				pushTable();
				if(statementList==NULL)
					typeViolation(line);
				if(init!=NULL)
					execStatement(init);
				nonTerm* ret = execStatement(statementList);
				popTable();
				return ret;
			}

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
			typeViolation(line);
	
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
				typeViolation(line);
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
				typeViolation(line);
			}
		break;
		}
		case STRING:{
			char* val1 = term1->value.str;
			char* val2 = term2->value.str;
			char* res;
			switch(tree->node.op){
			case PLUSy:
				res = malloc(sizeof(char)*1000);		//lol
				strcpy(res, val1);
				strcat(res, val2);
				free(val1);
				free(val2);	
				return mkNonTerm(STRING, res);
				break;
			}
		}
		case ARR:
			return mkNonTerm(ARR, tree->node.leaf);
		default:
			printf("type %d not implemented in ast\n", term1->type);
			typeViolation(line);
		}
	}
}
nonTerm* execStatement(statement* statem){
	if(statem==NULL)	//woah slow down there bub, you're not going anywhere
		return NULL;
	line = statem->lineno;
	switch(statem->command){
	case DECL:{	
		sym* head = statem->varDecl;
		head->name = statem->word1;
		arrType* thisType = statem->type;
		while(head!=NULL){
			if(head->term==NULL&&head->tree!=NULL)
				head->term = solveAst(head->tree);
			if(search(head->name)==NULL){	//Does not exist in sym table
				if(head->term==NULL){	//Declared but not initialized
					insert(thisType->type, head->name);
				} else{
					if(head->term->type!=thisType->type){		//Different type
						if(thisType->deg>1){	//Is ARR, need to check type

							//uhh let's skip the check for now

						} else {
							printf("Incompatible types\n");
							typeViolation(line);		
						} 
					}
					insert(thisType->type, head->name);
					if(head->term->arrType!=NULL)	//solves for var indexes
						head->term = mkNonTermArr(head->term->arrType->type, head->term->value.numArr);
					
					search(head->name)->term = head->term;
				}
			} else {
				typeViolation(line);		//Already declared
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
	case RET:{
		return solveAst(statem->exp);
		break;
	}
	default:
		printf("something bad happened %d\n", statem->command);
		typeViolation(line);
	}
	if(statem->next!=NULL)
		return execStatement(statem->next);

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

varType setType(char* type){
	if(!(strcmp(type, "String"))){
		return STRING;
	} else if(!(strcmp(type, "int"))){
		return INT;
	} else if(!(strcmp(type, "boolean"))){
		return BOOL;
	} else{
		printf("usermade types not implemented yet\n");
		typeViolation(line);
	}
}



int main(int argc, char** argv){
	pushTable();	//pushes main class symbol table to stack
	classes = malloc(sizeof(classList));	//init class list
	classesTail = classes;
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

	struct astListY;

	typedef enum varTypeY{
		UNDECY 		= -1,
		STRINGY 	= 0,
		INTY 		= 1,
		BOOLY		= 2,
		ARRY		= 3,
		ARRUNDECY	= 4,
		CLASSY		= 5
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
			struct astListY* numArr;
			struct classRefY* class;
		} value;
	} nonTermY;

	typedef struct nonTermArrY {
		int length;
		varTypeY type;
		nonTermY** term;
	} nonTermArrY;

	typedef struct classRefY {
		char* name;
		union subY{
			struct statementY* list;
			nonTermY* var;
		} sub;
	} classRefY;

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

	typedef struct astListY{
		astY* num;
		struct astListY* next;
	} astListY;

	typedef struct classLinkListY{
		char* name;
		astListY* exp;
		struct classLinkListY* next;
	} classLinkListY;

	typedef struct strArrY {
		char* str;
		astListY* num;
		classLinkListY* class;
	} strArrY;

	typedef struct symbolY {
		char* name;
		nonTermY* term;
		struct symbolY* next;
		astY* tree;
	} symY;


	typedef struct methodListY {
		char* name;
		arrTypeY* type;
		symY* arg;
		struct statementY* statementList;
		struct methodListY* next;
	} methodListY;

	typedef struct varMethodListY {
		symY* table;
		methodListY* methods;
	} varMethodListY;

	typedef struct classEntryY {
		char* name;
		varMethodListY* list;
	} classEntryY;

	typedef struct classListY {
		classEntryY* class;
		struct classList* next;	
	} classListY;

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
	astListY* numList;
	char* str;
	nonTermY term;
	arrTypeY* type;
	astY* tree;
	symY* termList;
	statementY* statem;
	strArrY* strarr;
	methodListY* methList;
	varMethodListY* varMethList;
	classEntryY* clEntry;
	classListY* clList;
}

%token<str> WORD STRING_LITERAL PRIMETYPE
%token<num> INTEGER_LITERAL
%type<strarr> LeftValue LeftValue2 NewFunc MethodCall
%type<num> BracketsList 
%type<numList> IndexList ExpList
%type<term> id 
%type<termList> VarInitList VarDecl VarInit FormalList FormalListMaybe
%type<tree> Exp ExpP ExpP2 ExpOp Index
%type<type> Type
%type<statem> Statement StatementList MainClass Program
%type<methList> MethodDecl 
%type<varMethList> VarMethodDecl VarOrMethod VarMethodDeclList
%type<clEntry> ClassDecl
%type<clList> ClassDeclList


%%

Program:	
	MainClass ClassDeclList {
		execStatement((statement*)$1);
	}
	;

MainClass:
	CLASS id LBRACE HEADER LPARENTH PRIMETYPE BRACKETS id RPARENTH LBRACE StatementList RBRACE RBRACE {
		$$ = $11;
	}
	;

ClassDeclList:
	ClassDecl ClassDeclList {
		classInsert((classEntry*)$1);
	}
	|/*empty*/	{}
	;

ClassDecl:
	CLASS WORD ParentMaybe LBRACE VarMethodDeclList RBRACE	{
		classEntryY* class = malloc(sizeof(classEntryY));
		class->list = $5;
		class->name = $2;
		$$ = class;
	}
	;

ParentMaybe:
	Parent
	| /*empty*/
	;

Parent:
	EXTENDS id
	;

VarMethodDeclList:
	VarOrMethod VarMethodDeclList	{
		$1->methods->next = $2->methods;
		$$ = $1;	
	}
	| /*empty*/	{}
	;

VarOrMethod:
	Type WORD VarMethodDecl		{				//no vars yet
		if($3->methods==NULL){		//declare vars
			//statement* statem = mkStatement(DECLY, NULL, $2, NULL, NULL, (arrType*)$1, (sym*)$3);
			$3->table->term->arrType = $1;		//arrays dont work	
		} else {			//method
			$3->methods->type = $1;
			$3->methods->name = $2;
		}
		$$ = $3;
		
	}
	| PUBLIC Type WORD MethodDecl	{ 
		varMethodList* list = malloc(sizeof(varMethodList));
		list->methods = (methodList*)$4;
		list->methods->type = (arrType*)$2;
		list->methods->name = $3;
		$$ = (varMethodListY*)list;
	}
	;

VarMethodDecl:
	VarDecl {
		varMethodList* list = malloc(sizeof(varMethodList));
		list->table = (sym*)$1;
		$$ = (varMethodListY*)list;
		
	}
	| MethodDecl {
		varMethodList* list = malloc(sizeof(varMethodList));
		list->methods = (methodList*)$1;
		$$ = (varMethodListY*)list;
	}
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
		//var->term = (nonTermY*)solveAst((ast*)$2);
		var->tree = $2;
		$$ = var;
	}
	| /*empty*/			{
		symY* var = malloc(sizeof(symY));
		$$ = var;
	}	//dummy value
	;

MethodDecl:
	LPARENTH FormalListMaybe RPARENTH LBRACE StatementList RBRACE	{		//FIX
		methodList* methods = malloc(sizeof(methodList));
		methods->arg = (sym*)$2;
		methods->statementList = (statement*)$5;
		$$ = (methodListY*)methods;
	}
	;

FormalListMaybe:
	FormalList {
		$$ = $1;
	}
	| /*empty*/ {
		$$ = NULL;
	}
	;

FormalList:
	Type WORD {									//no array support
		symY* var = malloc(sizeof(symY));
		//var->term = (nonTermY*)solveAst((ast*)$2);
		var->name = $2;
		var->term = malloc(sizeof(nonTerm));
		var->term->arrType = $1;
		var->term->type = $1->type;
		$$ = var;
	}
	| Type WORD COMMA FormalList {
		symY* var = malloc(sizeof(symY));
		//var->term = (nonTermY*)solveAst((ast*)$2);
		var->name = $2;
		var->term = malloc(sizeof(nonTermY));
		var->term->arrType = $1;
		var->term->type = $1->type;
		var->next = $4;
		$$ = var;
	}

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
	| RETURN Exp SEMICOLON {
		statement* statem = mkStatement(RET, NULL, NULL, NULL, (ast*)$2, NULL, NULL);
		$$ = (statementY*)statem;
	}
	| MethodCall SEMICOLON {}
	;


MethodCall:
	LeftValue LPARENTH ExpList RPARENTH			{
		strArrY* this = $1;
		//symY* this2 = $3;

		classLinkList* current = (classLinkList*)$1->class;		
		while(current->next!=NULL)
			current=current->next;

		current->exp = (astList*)$3;

		$$ = $1;
	
	}
	| LeftValue LPARENTH RPARENTH				{
		$$ = $1;
	}
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
			$1->num = malloc(sizeof(astListY));
			$1->num->num = $3;
		} else {

		astListY* current = $1->num;
		while(current->next!=NULL)
			current = current->next;	//points to tail

		current->next = malloc(sizeof(astListY));
		current->next->num = $3;
	
		}
		$$ = $1;
	}
	| LeftValue DOT WORD		{
		if($1->class == NULL){		//first deg of array
			$1->class = malloc(sizeof(classLinkListY));
			$1->class->name = $3;
		} else {

		classLinkListY* current = $1->class;
		while(current->next!=NULL)
			current = current->next;	//points to tail

		current->next = malloc(sizeof(classLinkListY));
		current->next->name = $3;
	
		}
		$$ = $1;
		printf("zobbles!\n");
	}
	| NewFunc DOT WORD		{
		char* str = $3;
		$1->class = malloc(sizeof(classLinkListY));
		$1->class->name = $3;
		$$ = $1;
	}
	| THIS DOT WORD			{
	}
	;

NewFunc:
	NEW WORD LPARENTH RPARENTH	{
		strArrY* this = malloc(sizeof(strArrY));
		this->str = $2;
		$$ = this;
	}
	;

LeftValue2:	
	LeftValue2 LBRACK Index
	| LeftValue2 DOT id
	| LPARENTH NewFunc RPARENTH DOT id	{}					//dunno what to do with this
	;

IndexList:				//returns list of ints to define array
	Index LBRACK IndexList {
		$$ = malloc(sizeof(astListY));
		$$->num = $1;
		$$->next = $3;	
	}
	| Index {
		$$ = malloc(sizeof(astListY));
		$$->num = $1;
	}

Index:
	Exp RBRACK {
		$$ = $1;
	}
	;

ExpList:
	Exp {
		astList* list = malloc(sizeof(astList));
		list->num = (ast*)$1;
		$$ = (astListY*)list;
	}
	| Exp COMMA ExpList {
		astList* list = malloc(sizeof(astList));
		list->num = (ast*)$1;
		list->next = (astList*)$3;	
		$$ = (astListY*)list;
	}
	;

ExpOp:
	NOT ExpOp{
		int* zero = malloc(sizeof(int));
		*zero = 0;
		astY* zed = (astY*)mkLeaf(mkNonTerm(BOOLY, (void*)zero));
		$$ = (astY*)mkNode((ast*)$2, (ast*)zed, EQUIVALENTy);
	}
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
	| MethodCall {
		if($1!=NULL){
			$$ = (astY*)mkLeafStr((strArr*)$1);
		}	
	}
	| NewFunc {
	}
	| NEW Type LBRACK IndexList {		//CREATE ENTIRE ARRAY USING LIST OF INT
		$$ = (astY*)mkLeaf((nonTerm*)mkNonTerm(ARRUNDECY, (astList*)$4));
		$$->node.leaf->arrType = $2;

	}
	| LeftValue {
		if($1!=NULL){
			$$ = (astY*)mkLeafStr((strArr*)$1);
		}
	}
	| LeftValue DOT LENGTH		{}
	| MINUS ExpOp {
		int* neg = malloc(sizeof(int));
		*neg = -1;
		$$ = (astY*)mkNode((ast*)$2, (ast*)mkLeaf(mkNonTerm(INTY, (void*)neg)), STARY);
	}
	| PLUS ExpOp {
		$$ = $2;
	}					
	;

ExpP2: 
	ExpP2 STAR ExpOp		{$$ = (astY*)mkNode((ast*)$1, (ast*)$3, STARY);}
	| ExpP2 SLASH ExpOp		{$$ = (astY*)mkNode((ast*)$1, (ast*)$3, SLASHY);}
	| ExpOp				{$$ = $1;}
	;

ExpP:
	ExpP PLUS ExpP2			{$$ = (astY*)mkNode((ast*)$1, (ast*)$3, PLUSY);}
	| ExpP MINUS ExpP2		{$$ = (astY*)mkNode((ast*)$1, (ast*)$3, MINUSY);}
	| ExpP2				{$$ = $1;}
	;

Exp:
	Exp AND ExpP			{$$ = (astY*)mkNode((ast*)$1, (ast*)$3, ANDY);}
	| Exp OR ExpP			{$$ = (astY*)mkNode((ast*)$1, (ast*)$3, ORY);}
	| Exp LESS ExpP			{$$ = (astY*)mkNode((ast*)$1, (ast*)$3, LESSY);}
	| Exp GREAT ExpP		{$$ = (astY*)mkNode((ast*)$1, (ast*)$3, GREATY);}	
	| Exp LESSEQ ExpP		{$$ = (astY*)mkNode((ast*)$1, (ast*)$3, LESSEQY);}	
	| Exp GREATEQ ExpP		{$$ = (astY*)mkNode((ast*)$1, (ast*)$3, GREATEQY);}	
	| Exp EQUIVALENT ExpP		{$$ = (astY*)mkNode((ast*)$1, (ast*)$3, EQUIVALENTY);}
	| Exp NOTEQUAL ExpP		{$$ = (astY*)mkNode((ast*)$1, (ast*)$3, NOTEQUALY);}
	| ExpP
	;

id:
	WORD{
		if(search($1)!=NULL){
			memcpy((void*)&$$, (void*)search($1)->term, sizeof(nonTerm));
		} else{		//do something if not declared yet, idk what
		}
	}
	;

