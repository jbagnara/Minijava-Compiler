%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>

extern int yylineno;
extern FILE* yyin;
extern int yyparse();
extern int yylex();


struct nonTerm;
struct ast;
struct nonTerm* solveAst(struct ast*, int side);
struct astList;
struct strArr;
struct statement;
struct classEntry;
struct sym;

int BUFFSIZE = 100000;
char* buffer;
int buffindex = 0;
int checkBool = 1;
int checking = 1;
char* inpName;
int argnum = 0;
char* argname;
int labelnum = 0;
int offset = 4;

void typeViolation(int lineno){
	checkBool = 0;
	printf("Type Violation in Line %d\n", lineno);
	//exit(1);
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
	char* class;
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
	SLASHy		= 13,
	PARSEINTy	= 14
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
	int offset;
} sym;

typedef struct classRef {
	char* name;
	sym* table;		//symbol table stack
	sym* tableTail;
} classRef;

typedef struct symStack {		//symbol table stack for accessing classes
	sym* table;
	sym* tableTail;
	struct symStack* prev;
} symStack;

typedef struct argList {
} argList;

typedef struct methodList {
	char* name;
	arrType* type;
	sym* arg;
	char* label;
	nonTerm* ret;
	struct statement* statementList;
	struct methodList* next;
} methodList;

typedef struct varMethodList {
	sym* table;
	methodList* methods;
} varMethodList;

typedef struct classEntry {
	char* name;
	char* parent;
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
	int formalListBool;
} statement;



sym* head;		//head of current symbol table
sym* tail;
symStack* table;	//symbol table stack
statement* temp;
classList* classes;
classList* classesTail;
classEntry* currentClass;
classEntry* oldClass;
sym* currentObj;
sym* oldObj;
char** mainArgs;
int line = 0;

statement* important;

nonTerm* execStatement(statement*);
classEntry* classSearch(char*);
statement* declArgs(classEntry*);
void pushTable(sym*);
void popTable();

void clean(){
	head = NULL;
	tail = NULL;
	table = NULL;
	temp = NULL;
	currentClass = NULL;
	oldClass = NULL;
	currentObj = NULL;
	oldObj = NULL;
	offset = 0;
}

void writeBuff(char* inp, int check){
	if(check)
		return;
	char c = *inp;
	while(c!='\0'){
		buffer[buffindex] = c;
		buffindex++;
		inp++;
		c = *inp;
	}
}

void writeInstr(int check, char* op, int argc, ...){
	writeBuff("\t",check);
	writeBuff(op,check);
	writeBuff("\t",check);

	va_list args;
	va_start(args, argc);
	
	for(int x=0; x<argc; x++){
		if(x>0)
			writeBuff(", ", check);

		writeBuff(va_arg(args, char*),check);
	}
	va_end(args);
	writeBuff("\n",check);
}

char* mkLabel(int check){
	if(check)
		return "";
	char* label = malloc(sizeof(char)*30);
	sprintf(label, "B%d", labelnum);
	labelnum++;
	return label;
}

void writeLabel(char* label, int check){
	writeBuff("\n", check);
	writeBuff(label, check);
	writeBuff(":\n", check);
}

void writeFile(char* fname){

	int x=0;
	char* cmp = fname;
	while(*cmp!='\0'){
		if(!strcmp(".java", cmp))
			break;
		x++;
		cmp++;
	}

	char* name = malloc(sizeof(char)*(x+2));
	strcpy(name, fname);

	name[x]='.';
	name[x+1]='s';
	name[x+2]='\0';	
	//FILE* file = fopen(name, "w");
	FILE* file = fopen("test.s", "w");
	fwrite(buffer, sizeof(char), sizeof(char)*buffindex, file);
	free(name);
}

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
			term->value.class->name = ((strArr*)val)->str;
			
		}
	}
	return term;
}

nonTerm* searchNonTermArr(nonTerm* arr, astList* num){
	if(num==NULL)
		return arr;
	if(num->next==NULL){
		return arr->value.arr[solveAst(num->num, 0)->value.num];
	}
	return searchNonTermArr(arr->value.arr[solveAst(num->num, 0)->value.num], num->next);
}

nonTerm* mkNonTermArr(int type, astList* list){	//builds array given dimensions
	if(list == NULL){
		return mkNonTerm(type, NULL);		//leaf
	}

	int deg = solveAst(list->num, 0)->value.num;
	int size = deg*sizeof(type);
	nonTerm* arr = mkNonTerm(ARR, &deg);

	writeInstr(checking, "mov", 2, "r1", "r0");
	writeInstr(checking, "bl", 1, "malloc");

	for(int x=0; x<solveAst(list->num, 0)->value.num; x++){
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

void pushTable(sym* classObj){			//pushes new symbol table
	oldClass=currentClass;
	oldObj = currentObj;
	classRef* class;
	if(classObj!=NULL){
		class = classObj->term->value.class;
		currentClass=classSearch(class->name);
		currentObj=classObj;
	}
	symStack* thisTable = malloc(sizeof(symStack));

	if(classObj==NULL){
		thisTable->table = malloc(sizeof(sym));	//init sym linkedlist
		thisTable->table->term = malloc(sizeof(nonTerm));
		thisTable->tableTail = thisTable->table;
	} else {
		thisTable->table = class->table;
		thisTable->tableTail = class->tableTail;
	}
	
	if(table==NULL){
		table = thisTable;
	} else{ 
		table->tableTail = tail;
		thisTable->prev = table;
		table = thisTable;
	}
	head = table->table;
	tail = table->tableTail;
	tail->next = NULL;
}

void popTable(){
	currentClass=oldClass;
	currentObj = oldObj;
	table = table->prev;			//there should always be parent table
	//memcpy(head, table->table, sizeof(sym));
	//memcpy(tail, table->tableTail, sizeof(sym));
	tail = table->tableTail;
	head = table->table;
	//need to free...	maybe someday
}

void insert(varType type, char* name){
	tail->next = malloc(sizeof(sym));
	tail->next->term = malloc(sizeof(nonTerm));
	tail = tail->next;
	tail->name = strdup(name);
	//strcpy(tail->name, name);
	tail->term->type = type;

	//tail->value = value;

	//writeBuff(name, !checking);
	/*
	writeInstr(checking, "mov", 2, "r0", "#16"); 
	writeInstr(checking, "bl", 1, "malloc");
	
	char* tmparg = malloc(sizeof(char)*1000);
	sprintf(tmparg, "[SP, #%d]", offset);

	writeInstr(checking, "str", 2, "r0", tmparg);
	free(tmparg);
	*/

	int size = 16;

	if(!checking){
		switch(type){
		case INT: {
			size = 4;
			offset-= size;
			break;	
		}
		case STRING: {
			size = 16;
			offset-= size;
			break;
		}
		case BOOL: {
			size = 4;
			offset-= size;
			break;	
		}
		case ARR: {
			size =16;
			offset-= size;
			break;
		}
		case ARRUNDEC: {
			size =16;
			offset-= size;
			break;
		}

		default: {
			printf("%d assembler decl not written\n", type);
			typeViolation(line);
		}}

	}	
	
	tail->offset = offset;
	char* tmparg = malloc(sizeof(char)*1000);
	sprintf(tmparg, "#-%d", size);
	//writeInstr(checking, "ldr", 2, "r4", tmparg);
	writeInstr(checking, "add", 3, "sp", "sp", tmparg);
	free(tmparg);

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

methodList* methodSearch(classEntry* class, char* methodName){
	if(class==NULL)	//class not found
		typeViolation(line);

	methodList* current = class->list->methods;
	while(current!=NULL){
		if(!strcmp(methodName, current->name))
			return current;
		current = current->next;
	}
	if(class->parent!=NULL&&classSearch(class->parent)!=NULL){
			return methodSearch(classSearch(class->parent), methodName);	
	}
	return NULL;
	
}

void writeMethods(){		//writes all methods

	classList* list = classes->next;
	while(list!=NULL){
		classEntry* currentClass = list->class;
		if(currentClass==NULL)
			return;

		methodList* currentMethod = currentClass->list->methods;
		while(currentMethod!=NULL){
			writeLabel(currentMethod->label, checking);
			writeInstr(checking, "push", 1, "{r1-r4, lr}");
			currentMethod->ret = execStatement(currentMethod->statementList);
			writeInstr(checking, "pop", 1, "{r1-r4, pc}");
			currentMethod=currentMethod->next;	
		}
		list = list->next;
	}


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

void initArgs(sym* list, sym* input){			//do type checks! ***
		
	//statement* current = mkStatement(DECL, NULL, list->name,  NULL, NULL, list->term->arrType, list);
	//current->formalListBool=1;
	//statement* stateHead = current;
	sym* itr = list;
	while(input!=NULL&&itr!=NULL){	
		strArr* this = malloc(sizeof(strArr));
		this->str = itr->name;
		if(this->str==NULL||input->term==NULL)
			return;

		char* arg = malloc(sizeof(char)*1000);
		arg[0] = '=';
		strcpy(arg+1, this->str);
		writeInstr(checking, "ldr", 2, "r4", arg);
		free(arg);

		solveAst(mkLeaf(input->term), 0);
		writeInstr(checking, "str", 2, "r0", "[r4]");

		writeBuff(this->str, !checking);		//declare instance var
		writeBuff(": .word 0\n", !checking);

		//current->next = mkStatement(INIT, NULL, NULL, this, mkLeaf(input->term), NULL, NULL);
		input = input->next;
		itr = itr->next;
	}
	return; 

	//statement* statem = mkStatement(DECLY, NULL, $2, NULL, NULL, (arrType*)$1, (sym*)$3);
	//statement* statem = mkStatement(INIT, NULL, NULL, (strArr*)$1, (ast*)$3, NULL, NULL);
}

statement* declArgs(classEntry* class){
	sym* list = class->list->table;
	statement* current = NULL;
	if(list!=NULL) {
		sym* temp = malloc(sizeof(ast));
		memcpy((void*)temp, (void*)list, sizeof(sym));
		temp->term = malloc(sizeof(nonTerm));	
		memcpy((void*)temp->term, (void*)list->term, sizeof(sym));
		current = mkStatement(DECL, NULL, list->name,  NULL, NULL, list->term->arrType, temp);
		temp->term->arrType=NULL;
		current->formalListBool=1;
	}

	if(class->parent!=NULL&&classSearch(class->parent)!=NULL){
		if(current == NULL)
			current = declArgs(classSearch(class->parent));
		else
			current->next = declArgs(classSearch(class->parent));
	}

	return current;
}

void initInputArgs(char* name){
	/*astList* deg = malloc(sizeof(astList));
	int* hundert = malloc(sizeof(int));
	*hundert = argnum;
	deg->num = mkLeaf(mkNonTerm(INT, hundert));
	sym* inputArgs;
	sym* inpHead;
	char** itr = mainArgs;

	sym* inputArgs = malloc(sizeof(sym));
	inputArgs->tree = mkLeaf(mkNonTerm(STRING, mainArgs[0]));

	insert(ARR, name);	

	solveAst(mkLeaf(inputArgs->term), 0);
	char* tmparg = malloc(sizeof(char)*1000);
	sprintf(tmparg, "=%s", name);
	writeInstr(checking, "ldr", 2, "r4", tmparg);
	writeInstr(checking, "str", 2, "r0", "[r4]");
	free(tmparg);

	//nonTerm* arr = mkNonTermArr(STRING, deg);
	//search(name)->term = arr;
	
	*/

	insert(STRING, name);
	search(name)->term = mkNonTerm(STRING, "");
	int x=0;
	/*while(itr[x]!=NULL){
		inputArgs = malloc(sizeof(sym));
		inputArgs->tree = mkLeaf(mkNonTerm(STRING, itr));
		if(inpHead==NULL)
			inpHead = inputArgs;
		inputArgs = inputArgs->next;
		memcpy((void*)searchNonTermArr(search(name)->term, x), mkNonTerm(STRING, itr), sizeof(nonTerm));
		memcpy(search(name)->term->value.arr[x], mkNonTerm(STRING, itr[x]), sizeof(nonTerm));
		x++;
		itr++;
	}*/

}

void printExp(nonTerm* term, int nline){
	if(checking)	//don't you dare!
		return;
	switch(term->type){
	case STRING:		//String
		if(nline){
			writeInstr(checking, "mov", 2, "r1", "r0");
			writeInstr(checking, "ldr", 2, "r0", "=snewln");
			writeInstr(checking, "bl", 1, "printf");
		} else {
			writeInstr(checking, "bl", 1, "printf");	
		}
		break;
	case INT:		//int
		if(nline){
			writeInstr(checking, "mov", 2, "r1", "r0");
			writeInstr(checking, "ldr", 2, "r0", "=newln");
			writeInstr(checking, "bl", 1, "printf");
		}
		else {
			writeInstr(checking, "mov", 2, "r1", "r0");
			writeInstr(checking, "ldr", 2, "r0", "=noln");
			writeInstr(checking, "bl", 1, "printf");
		}	
		break;
	case BOOL:
		writeInstr(checking, "cmp", 2, "r0", "#1");
		char* label1 = mkLabel(checking);
		char* label2 = mkLabel(checking);
		if(nline){
			writeInstr(checking, "beq", 1, label1);
			writeInstr(checking, "ldr", 2, "r0", "=falseln");
			writeInstr(checking, "bl", 1, label2);
			writeLabel(label1, checking);
			writeInstr(checking, "ldr", 2, "r0", "=trueln");
			
		} else {
			writeInstr(checking, "beq", 1, label1);
			writeInstr(checking, "ldr", 2, "r0", "=false");
			writeInstr(checking, "bl", 1, label2);
			writeLabel(label1, checking);
			writeInstr(checking, "ldr", 2, "r0", "=true");
		}
		writeLabel(label2, checking);
		writeInstr(checking, "bl", 1, "printf");
		break;
	case ARR:
		printf("uhh\n");
		typeViolation(line);
		break;
	case CLASSy:
		printf("ya");		
	default:
		typeViolation(line);
	}
}

nonTerm* solveAst(ast* tree, int side){		//reduces ast tree to single nonTerm
	if(tree->isLeaf){
		if (tree->isVar){	//var
			if(tree->str->class!=NULL){		//class shenanigans
				if(checking&&currentClass!=NULL)
					return mkNonTerm(INT, NULL);
				int objBool = 0;
				
				//gotta convert input to terms with solveAst!!
				if(tree->str->str==NULL){		//THIS
					if(currentObj==NULL)
						tree->str->str = currentClass->name;
					else
						tree->str->str = currentObj->name;
				}

				sym* obj;
				classEntry* thisClass = classSearch(tree->str->str);
				if(thisClass==NULL){
					if(search(tree->str->str)!=NULL){		//object of class
						if(checking)		//donnt want that
							return NULL;
						obj = search(tree->str->str);
						thisClass = classSearch(obj->term->value.class->name);
						objBool = 1;
					} else if (!strcmp(tree->str->str, currentObj->name)){
						obj = currentObj;
						thisClass = classSearch(obj->term->value.class->name);
						objBool = 1;
						
					}
					else
						return NULL;
				}
				
				
				methodList* method = methodSearch(thisClass, tree->str->class->name);
				if(method==NULL){
					return NULL;
				}
				statement* statementList = method->statementList;
				astList* input = tree->str->class->exp;
				sym* formInput = malloc(sizeof(sym));
				sym* formhead = formInput;
				while(input!=NULL){
					formInput->term = solveAst(input->num, 0);
					formInput->next = malloc(sizeof(sym));
					formInput = formInput->next;
					input = input->next;
				}	
				
				if(statementList==NULL)
					typeViolation(line);

				if(objBool){
					pushTable(obj);
				}
				else {
					pushTable(NULL);
					currentClass = thisClass;
				}
				//nonTerm* ret = execStatement(statementList);
				initArgs(method->arg, formhead);		//this will need to be changed
				writeInstr(checking, "bl", 1, method->label);		//branch to method
				
				popTable();
				return method->ret;
			}
		
			if(search(tree->str->str)==NULL){
				typeViolation(line);
				return NULL;
			}	
			tree->node.leaf =  search(tree->str->str)->term;
			if(tree->node.leaf->type==ARR){	//arr
				tree->node.leaf=searchNonTermArr(search(tree->str->str)->term, tree->str->num); 
			} 

			char* tmparg = malloc(sizeof(char)*1000);
			sprintf(tmparg, "[fp, #%d]", search(tree->str->str)->offset);
			writeInstr(checking, "ldr", 2, "r0", tmparg);
			free(tmparg); 

			//writeInstr(checking, "ldr", 2, "r0", "[r4]");
			return tree->node.leaf;
		}

		switch(tree->node.leaf->type){
		case INT:{
			char* arg = malloc(sizeof(char)*1000);
			sprintf(arg, "#%d", tree->node.leaf->value.num);
			writeInstr(checking, "mov", 2, "r0", arg); 
			free(arg);
			break;
		}

		case BOOL:{
			char* arg = malloc(sizeof(char)*1000);
			sprintf(arg, "#%d", tree->node.leaf->value.num);
			writeInstr(checking, "mov", 2, "r0", arg); 
			free(arg);
			break;
		}

		case STRING:{
			char* thisStr = tree->node.leaf->value.str;
			int size = 0;		//size to malloc
			while(*thisStr!='\0'){
				size++;
				thisStr++;
			}
			size++;	//for \0
			size++;
			thisStr = tree->node.leaf->value.str;

			char* arg = malloc(sizeof(char)*1000);
			sprintf(arg, "#%d", size);	
			writeInstr(checking, "mov", 2, "r0", arg);

			writeInstr(checking, "bl", 1, "malloc");		//idk if i have to free this later
			writeInstr(checking, "mov", 2, "r2", "r0");
			while(*thisStr!='\0'){
				sprintf(arg, "#%d", *thisStr);
				writeInstr(checking, "mov", 2, "r1", arg);
				writeInstr(checking, "str", 2, "r1", "[r0]");
				writeInstr(checking, "add", 3, "r0", "r0", "#1");
				thisStr++;
			}
			sprintf(arg, "#0");
			writeInstr(checking, "mov", 2, "r1", arg);
			writeInstr(checking, "str", 2, "r1", "[r0]");
			free(arg);
			
			writeInstr(checking, "mov", 2, "r0", "r2");
			break;
		}}
		
		return tree->node.leaf;
	} else {
		nonTerm* term1 = solveAst(tree->node1, 0);
		writeInstr(checking, "push", 1, "{r0}");	//push r0 onto stack
		nonTerm* term2 = solveAst(tree->node2, 1);
		writeInstr(checking, "mov", 2, "r1", "r0");
		writeInstr(checking, "pop", 1, "{r0}");		//pop r0 back off

		if(term1==NULL){
			return NULL;
		}
		if(term2!=NULL&&term1->type!=term2->type)
			return NULL;
		if(checking)
			return term1;

		switch(term1->type){
		case INT:{

			switch(tree->node.op){
			case STARy:
				writeInstr(checking, "mul", 3, "r0", "r0", "r1");
				break;
			case SLASHy:
				break;
			case PLUSy:
				writeInstr(checking, "add", 3, "r0", "r0", "r1");
				break;
			case MINUSy:
				writeInstr(checking, "sub", 3, "r0", "r0", "r1");
				break;
			case LESSy:
				writeInstr(checking, "cmp", 2, "r0", "r1");
				writeInstr(checking, "mov", 2, "r0", "#0");
				writeInstr(checking, "movlt", 2, "r0", "#1");
				return mkNonTerm(BOOL, mkLeaf(term1));
				break;
			case GREATy:
				writeInstr(checking, "cmp", 2, "r0", "r1");
				writeInstr(checking, "mov", 2, "r0", "#0");
				writeInstr(checking, "movgt", 2, "r0", "#1");
				return mkNonTerm(BOOL, mkLeaf(term1));
				break;
			case LESSEQy:
				writeInstr(checking, "cmp", 2, "r0", "r1");
				writeInstr(checking, "mov", 2, "r0", "#1");
				writeInstr(checking, "movgt", 2, "r0", "#0");
				return mkNonTerm(BOOL, mkLeaf(term1));
				break;
			case GREATEQy:
				writeInstr(checking, "cmp", 2, "r0", "r1");
				writeInstr(checking, "mov", 2, "r0", "#1");
				writeInstr(checking, "movlt", 2, "r0", "#0");
				return mkNonTerm(BOOL, mkLeaf(term1));
				break;
			case EQUIVALENTy:
				writeInstr(checking, "cmp", 2, "r0", "r1");
				writeInstr(checking, "mov", 2, "r0", "#0");
				writeInstr(checking, "moveq", 2, "r0", "#1");
				return mkNonTerm(BOOL, mkLeaf(term1));
				break;
			case NOTEQUALy:
				writeInstr(checking, "cmp", 2, "r0", "r1");
				writeInstr(checking, "mov", 2, "r0", "#1");
				writeInstr(checking, "moveq", 2, "r0", "#0");
				return mkNonTerm(BOOL, mkLeaf(term1));
				break;
			default:
				typeViolation(line);
			}
			if(side)
				writeInstr(checking, "mov", 2, "r1", "r0");
			return term1;
		break;
		}
		case BOOL:{
			//int val1 = term1->value.num;
			//int val2 = term2->value.num;
			//int res;
			switch(tree->node.op){
			case EQUIVALENTy:
				writeInstr(checking, "cmp", 2, "r0", "r1");
				writeInstr(checking, "mov", 2, "r0", "#0");
				writeInstr(checking, "moveq", 2, "r0", "#1");
				break;
			case NOTEQUALy:
				writeInstr(checking, "cmp", 2, "r0", "r1");
				writeInstr(checking, "mov", 2, "r0", "#1");
				writeInstr(checking, "moveq", 2, "r0", "#0");
				break;
			case ANDy:
				writeInstr(checking, "cmp", 2, "r0", "r1");
				writeInstr(checking, "mov", 2, "r0", "#0");
				writeInstr(checking, "moveq", 2, "r0", "#1");
				writeInstr(checking, "cmp", 2, "r1", "#0");
				writeInstr(checking, "moveq", 2, "r0", "#0");	//mov 1 if equal, then 0 if false	
				break;
			case ORy:
				writeInstr(checking, "cmp", 2, "r0", "#1");
				writeInstr(checking, "mov", 2, "r0", "#0");
				writeInstr(checking, "moveq", 2, "r0", "#1");
				writeInstr(checking, "cmp", 2, "r1", "#1");
				writeInstr(checking, "moveq", 2, "r0", "#1");
				break;
			default:
				printf("invalid bool operation %d\n", term1->type );
				typeViolation(line);
			}
			if(side)
				writeInstr(checking, "mov", 2, "r1", "r0");
			return term1;
		break;
		}
		case STRING:{
			char* val1 = term1->value.str;
			char* val2 = term2->value.str;
			char* res;
			if(val1==NULL){
				typeViolation(line);
				return NULL;
			}
			switch(tree->node.op){
			case PLUSy:{
				char* thisStr = val1;
				int size1 = 0;
				int size2 = 0;
				while(*thisStr!='\0'){
					size1++;
					thisStr++;
				}
				thisStr = val2;
				while(*thisStr!='\0'){
					size2++;
					thisStr++;
				}
				writeInstr(checking, "mov", 2, "r2", "r1");
				writeInstr(checking, "mov", 2, "r1", "r0");	
				char* arg = malloc(sizeof(char)*1000);
				sprintf(arg, "#%d", size1+size2);	
				writeInstr(checking, "mov", 2, "r0", arg);
				free(arg);

				writeInstr(checking, "push", 1, "{r1-r3}");
				writeInstr(checking, "bl", 1, "malloc");
				writeInstr(checking, "pop", 1, "{r1-r3}");	//malloc to r0

				writeInstr(checking, "mov", 2, "r3", "r1");
				writeInstr(checking, "push", 1, "{r1-r2}");
				writeInstr(checking, "mov", 2, "r1", "r3");
				writeInstr(checking, "bl", 1, "strcat");
				writeInstr(checking, "pop", 1, "{r1-r2}");

				writeInstr(checking, "mov", 2, "r3", "r2");
				writeInstr(checking, "push", 1, "{r1-r2}");
				writeInstr(checking, "mov", 2, "r1", "r3");
				writeInstr(checking, "bl", 1, "strcat");
				writeInstr(checking, "pop", 1, "{r1-r2}");
				writeInstr(checking, "mov", 2, "r1", "r2");	//move r3 back to r0 and cpy r2 to r0
				
				break;
			}
			case PARSEINTy:{
				writeInstr(checking, "bl", 1, "atoi");
				return mkNonTerm(INT, mkLeaf(term1));
				break;
			}
			default:
				typeViolation(line);
			}
			if(side)
				writeInstr(checking, "mov", 2, "r1", "r0");
			return term1;
		break;
		}
		case ARR:
			break;
		case CLASSy:
		default:
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
		sym* check = malloc(sizeof(sym));
		memcpy((void*)check, (void*)statem->varDecl, sizeof(sym));
		check->name = statem->word1;
		arrType* thisType = statem->type;

		if(thisType==NULL||check==NULL)
			typeViolation(line);

		while(check!=NULL){
			if(check->term==NULL&&check->tree!=NULL){
				if(checking)
					check->term = solveAst(check->tree, 0);
				else {
					checking = 1;
					check->term = solveAst(check->tree, 0);
					checking = 0;
				}
			}
			if(search(check->name)==NULL){	//Does not exist in sym table
				if(check->term==NULL){	//Declared but not initialized
					insert(thisType->type, check->name);
				} else{
					if(check->term->type!=thisType->type){		//Different type
						if(thisType->deg>1){	//Is ARR, need to check type
							if (thisType->type!=check->term->arrType->type) {
								typeViolation(line);
								check = check->next;
								continue;		
							}

							writeInstr(checking, check->name, 0);

						} else if(!statem->formalListBool) {
							if(check->tree->node.op==PARSEINTy){
								insert(INT, check->name);
								solveAst(check->tree, 0);
								char* tmparg = malloc(sizeof(char)*1000);
								//sprintf(tmparg, "[fp, #%d]", search(check->name)->offset);
								//writeInstr(checking, "ldr", 2, "r4", tmparg);
								//writeInstr(checking, "str", 2, "r0", "[r4]");
								sprintf(tmparg, "[fp, #%d]", search(check->name)->offset);
								writeInstr(checking, "str", 2, "r0", tmparg);
								free(tmparg);
								break;	
							}
							typeViolation(line);
							check = check->next;
							continue;		
						} else if(thisType->type==CLASSy){
							typeViolation(line);
							check = check->next;
							continue;		
						} 
					}

					if(thisType->type==CLASSy){
						if(classSearch(check->term->value.class->name)==NULL||
						  (strcmp(check->term->value.class->name, thisType->class))){
							typeViolation(line);
							return NULL;
						}	
						statement* init = declArgs(classSearch(check->term->value.class->name));
						pushTable(NULL);			//creates empty symbol table
						check->term->value.class->table = head;
						execStatement(init);
						check->term->value.class->tableTail = tail;
						popTable();
					}
					insert(check->term->type, check->name);
					solveAst(check->tree, 0);

					char* tmparg = malloc(sizeof(char)*1000);
					sprintf(tmparg, "[fp, #%d]", search(check->name)->offset);
					writeInstr(checking, "str", 2, "r0", tmparg);
					free(tmparg);

					if(check->term->arrType!=NULL)	//solves for var indexes
						check->term = mkNonTermArr(check->term->arrType->type, check->term->value.numArr);
					if(check->term==NULL){
						typeViolation(line);
						check = check->next;
						continue;		
					}
					
					search(check->name)->term = check->term;
				}
			} else {
				typeViolation(line);		//Already declared
				break;
			}
			check = check->next;
		}
		break;
	}
	case PRINTNLINE:{
		nonTerm* ret = solveAst(statem->exp, 0);
		if(checking)
			break;
		printExp(ret, 1);
		break;		
	}
	case PRINTN:{
		nonTerm* ret = solveAst(statem->exp, 0);
		if(checking)
			break;
		if(ret==NULL || ( ret->type!=BOOL && ret->type!=INT && ret->value.str==NULL)){
			typeViolation(line);
			break;
		}
		printExp(ret, 0);
		break;		
	}
	case INIT:{		
		sym* head = search(statem->leftVal->str);
		if(head==NULL){
			typeViolation(line);
			break;
		}
		if(head->term->arrType!=NULL)				//solves for var indexes
			head->term = mkNonTermArr(head->term->arrType->type, head->term->value.numArr);
					
		
		//memcpy((void*)searchNonTermArr(search(head->name)->term, statem->leftVal->num), (void*)solveAst(statem->exp, 0), sizeof(nonTerm));			//copies exp to the symbol table pointer
		solveAst(statem->exp, 0);
		//insert r0 into var
		char* tmparg = malloc(sizeof(char)*1000);
		sprintf(tmparg, "[fp, #%d]", search(head->name)->offset);
		writeInstr(checking, "str", 2, "r0", tmparg);
		free(tmparg);

		break;
	}
	case WHILEN:{
		//if(checking){
		//	execStatement(statem->sub1);
		//	break;
		//}
		char* b1 = mkLabel(checking);
		char* b2 = mkLabel(checking);
		writeLabel(b1, checking);

		solveAst(statem->conditional, 0);
		//char* tmparg = malloc(sizeof(char)*1000);
		//sprintf(tmparg, "[SP, #%d]", search(head->name)->offset);
		writeInstr(checking, "cmp", 2, "r0", "#0");
		writeInstr(checking, "beq", 1, b2);

		//while(solveAst(statem->conditional, 0)->value.num)
		execStatement(statem->sub1);
		writeInstr(checking, "b", 1, b1);
		writeLabel(b2, checking);
		//free(tmparg);

		break;
	}
	case IFELSE:{
		//if(checking){
		//	execStatement(statem->sub1);
		//	execStatement(statem->sub2);
		//	break;	
		//}

		//if(solveAst(statem->conditional, 0)->value.num)
		//	execStatement(statem->sub1);
		//else
		//	execStatement(statem->sub2);

		char* b1 = mkLabel(checking);		//start of else
		char* b2 = mkLabel(checking);		//end of else

		solveAst(statem->conditional, 0);
		//char* tmparg = malloc(sizeof(char)*1000);
		//sprintf(tmparg, "[SP, #%d]", search(head->name)->offset);
		writeInstr(checking, "cmp", 2, "r0", "#0");
		writeInstr(checking, "beq", 1, b1);
		execStatement(statem->sub1);
		writeInstr(checking, "b", 1, b2);
		writeLabel(b1, checking);
		execStatement(statem->sub2);
		writeLabel(b2, checking);	

		//free(tmparg);
		

		break;
	}
	case RET:{
		return solveAst(statem->exp, 0);
		
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
	argnum = argc;
	pushTable(NULL);	//pushes main class symbol table to stack 
	buffer = malloc(sizeof(char)*BUFFSIZE);
	writeBuff(".data\n", 0);	
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
	mainArgs = argv+2;
	yyin = file;
	yyparse();
	//free(head->term);
	//free(head);
	if(argc>1)
		fclose(file);
	writeFile(fname);

	//printall();	
}

%}
%token<num> AND OR LESS GREAT LESSEQ GREATEQ EQUAL NOTEQUAL PLUS MINUS STAR SLASH LBRACK RBRACK LBRACE RBRACE LPARENTH RPARENTH EXTENDS HEADER CLASS IF WHILE NOT TRUE FALSE PUBLIC COMMA EQUIVALENT SEMICOLON PRINT PRINTLN DOT NEW THIS RETURN LENGTH ELSE BRACKETS PARSEINT

%code requires{

	struct astListY;
	struct classEntryY;
	struct symY;

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
		char* class;
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
		SLASHY		= 13,
		PARSEINTY	= 14
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
		int offset;
	} symY;

	typedef struct classRefY {
		char* name;
		symY* table;
		symY* tableTail;
	} classRefY;


	typedef struct methodListY {
		char* name;
		arrTypeY* type;
		symY* arg;
		char* label;
		nonTermY* ret;
		struct statementY* statementList;
		struct methodListY* next;
	} methodListY;

	typedef struct varMethodListY {
		symY* table;
		methodListY* methods;
	} varMethodListY;

	typedef struct classEntryY {
		char* name;
		char* parent;
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
%type<str> Parent ParentMaybe
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
		writeBuff("newln: .asciz \"%d\\n\"\n", !checking);	//newln decimal
		writeBuff("noln: .asciz \"%d\"\n", !checking);		//no newln decimal
		writeBuff("snewln: .asciz \"%s\\n\"\n", !checking);	//newln string
		writeBuff("true: .asciz \"True\"\n", !checking);		//true
		writeBuff("false: .asciz \"False\"\n", !checking);	//false
		writeBuff("trueln: .asciz \"True\\n\"\n", !checking);		//true newline
		writeBuff("falseln: .asciz \"False\\n\"\n", !checking);	//false newline
		

		execStatement((statement*)$1);
		clean();
		pushTable(NULL);
		checking = 0;
		writeBuff(".text\n"
			".global main\n",
			checking);

		writeMethods();
		
		writeBuff("\nmain:\n"
			"\tpush\t{fp, lr}\n",
			checking);

		//we gon move our boys

		if(checkBool){
			writeBuff("\tmov\tfp, sp\n", checking);
			initInputArgs(inpName);
			char* tmparg = malloc(sizeof(char)*1000);
			sprintf(tmparg, "[fp, #%d]", search(inpName)->offset);
			writeInstr(checking, "ldr", 2, "r4", tmparg);
			writeInstr(checking, "ldr", 2, "r1", "[r1, #4]");
			writeInstr(checking, "str", 2, "r1", "[fp, #-16]");
			free(tmparg);

			execStatement((statement*)$1);
			writeBuff("\tmov\tsp, fp\n", checking);
			writeBuff("\tpop\t{fp, pc}\n", checking);
		}

	}
	;

MainClass:
	CLASS id LBRACE HEADER LPARENTH PRIMETYPE BRACKETS WORD RPARENTH LBRACE StatementList RBRACE RBRACE {
		inpName = $8;
		writeBuff("inp: .", checking);
		writeBuff($8, checking);
		writeBuff(" .word\n", checking);
		initInputArgs($8);
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
		class->parent = $3;
		$$ = class;
	}
	;

ParentMaybe:
	Parent {
		$$ = $1;
	}
	| /*empty*/ {
		$$ = NULL;
	}
	;

Parent:
	EXTENDS WORD {
		$$ = $2;
	}
	;

VarMethodDeclList:
	VarOrMethod VarMethodDeclList	{
		if($2!=NULL){
			if($1->methods==NULL)
				$1->methods = $2->methods;
			else if($2->methods!=NULL)
				$1->methods->next = $2->methods;
			if($1->table==NULL)
				$1->table = $2->table;
			else if($2->table!=NULL)
				$1->table->next = $2->table;
		}
		$$ = $1;	
	}
	| /*empty*/	{
		$$ = NULL;		
	}
	;

VarOrMethod:
	Type WORD VarMethodDecl		{				//no vars yet
		if($3->methods==NULL){		//declare vars
			//statement* statem = mkStatement(DECLY, NULL, $2, NULL, NULL, (arrType*)$1, (sym*)$3);
			if($3->table->tree!=NULL)
				$3->table->term = (nonTermY*)solveAst((ast*)$3->table->tree, 0);
			else
				$3->table->term = malloc(sizeof(nonTerm));
			$3->table->next = NULL;
			$3->table->term->arrType = $1;		//arrays dont work	
			$3->table->name = $2;
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
		methods->label = mkLabel(0);		//store future label for method
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
	PRIMETYPE BracketsList {
		$$ = malloc(sizeof(arrTypeY));
		$$->type = setType($1);
		$$->deg = $2;
	}
	| WORD BracketsList{
		$$ = malloc(sizeof(arrTypeY));
		$$->type = CLASSy;
		$$->class = $1;
	}

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
	LeftValue LPARENTH ExpList RPARENTH {
		strArrY* this = $1;
		//symY* this2 = $3;

		classLinkList* current = (classLinkList*)$1->class;		
		while(current->next!=NULL)
			current=current->next;

		current->exp = (astList*)$3;

		$$ = $1;
	
	}
	| LeftValue LPARENTH RPARENTH {
		$$ = $1;
	}
	;

LeftValue:
	WORD {
		//if(search($1)!=NULL)
			strArrY* this = malloc(sizeof(strArrY));
			this->str = $1;
			$$ = this;
			//$$ = (symY *)search($1);
		//else
		//	typeViolation();
	}
	| LeftValue LBRACK Index {
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
	| LeftValue DOT WORD {
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
	}
	| NewFunc DOT WORD {
		char* str = $3;
		$1->class = malloc(sizeof(classLinkListY));
		$1->class->name = $3;
		$$ = $1;
	}
	| THIS DOT WORD	{
		char* str = $3;
		strArrY* this = malloc(sizeof(strArrY));
		

		this->class = malloc(sizeof(classLinkListY));
		this->class->name = $3;	
		$$ = this;
	}
	;

NewFunc:
	NEW WORD LPARENTH RPARENTH {
		strArrY* this = malloc(sizeof(strArrY));
		this->str = $2;
		$$ = this;
	}
	;

LeftValue2:	
	LeftValue2 LBRACK Index {
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
	| LeftValue2 DOT WORD {
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
	}
	| LPARENTH NewFunc RPARENTH DOT WORD {
		char* str = $5;
		$2->class = malloc(sizeof(classLinkListY));
		$2->class->name = $5;
		$$ = $2;

	}					//dunno what to do with this
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
		$$ = (astY*)mkLeaf(mkNonTerm(CLASSY, $1));
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
	| PARSEINT LPARENTH Exp RPARENTH {
		$$ = (astY*)mkNode((ast*)$3, (ast*)$3, PARSEINTY);
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

