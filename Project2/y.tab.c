/* A Bison parser, made by GNU Bison 3.4.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2019 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.4"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* First part of user prologue.  */
#line 1 "parser.y"

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


void typeViolation(){
	printf("Type Violation in Line %d\n", yylineno);
	exit(1);
}

typedef enum varType{
	UNDEC	 = -1,
	STRING	 = 0,
	INT	 = 1,
	BOOL	 = 2,
	ARR	 = 3
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
	int deg;
	union value{
		char* str;
		int num;
		struct nonTerm** arr;	
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
	if(num->next==NULL)
		return arr->value.arr[solveAst(num->num)->value.num];
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
			if(tree->node.leaf->type==ARR)	//arr
				tree->node.leaf=searchNonTermArr(search(tree->str->str)->term, tree->str->num); 
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
		memcpy((void*)searchNonTermArr(search(statem->leftVal->str)->term, statem->leftVal->num), (void*)solveAst(statem->exp), sizeof(nonTerm));
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


#line 566 "y.tab.c"

# ifndef YY_NULLPTR
#  if defined __cplusplus
#   if 201103L <= __cplusplus
#    define YY_NULLPTR nullptr
#   else
#    define YY_NULLPTR 0
#   endif
#  else
#   define YY_NULLPTR ((void*)0)
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Use api.header.include to #include this header
   instead of duplicating it here.  */
#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif
/* "%code requires" blocks.  */
#line 498 "parser.y"

	typedef enum varTypeY{
		UNDECY 	= -1,
		STRINGY = 0,
		INTY 	= 1,
		BOOLY	= 2,
		ARRY	= 3
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
		int degY;
		union valueY{
			char* str;
			int num;
			struct nonTerm** arr;	
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


#line 703 "y.tab.c"

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    AND = 258,
    OR = 259,
    LESS = 260,
    GREAT = 261,
    LESSEQ = 262,
    GREATEQ = 263,
    EQUAL = 264,
    NOTEQUAL = 265,
    PLUS = 266,
    MINUS = 267,
    STAR = 268,
    SLASH = 269,
    LBRACK = 270,
    RBRACK = 271,
    LBRACE = 272,
    RBRACE = 273,
    LPARENTH = 274,
    RPARENTH = 275,
    EXTENDS = 276,
    HEADER = 277,
    CLASS = 278,
    IF = 279,
    WHILE = 280,
    NOT = 281,
    TRUE = 282,
    FALSE = 283,
    PUBLIC = 284,
    COMMA = 285,
    EQUIVALENT = 286,
    SEMICOLON = 287,
    PRINT = 288,
    PRINTLN = 289,
    DOT = 290,
    NEW = 291,
    THIS = 292,
    RETURN = 293,
    LENGTH = 294,
    ELSE = 295,
    BRACKETS = 296,
    WORD = 297,
    STRING_LITERAL = 298,
    PRIMETYPE = 299,
    INTEGER_LITERAL = 300
  };
#endif
/* Tokens.  */
#define AND 258
#define OR 259
#define LESS 260
#define GREAT 261
#define LESSEQ 262
#define GREATEQ 263
#define EQUAL 264
#define NOTEQUAL 265
#define PLUS 266
#define MINUS 267
#define STAR 268
#define SLASH 269
#define LBRACK 270
#define RBRACK 271
#define LBRACE 272
#define RBRACE 273
#define LPARENTH 274
#define RPARENTH 275
#define EXTENDS 276
#define HEADER 277
#define CLASS 278
#define IF 279
#define WHILE 280
#define NOT 281
#define TRUE 282
#define FALSE 283
#define PUBLIC 284
#define COMMA 285
#define EQUIVALENT 286
#define SEMICOLON 287
#define PRINT 288
#define PRINTLN 289
#define DOT 290
#define NEW 291
#define THIS 292
#define RETURN 293
#define LENGTH 294
#define ELSE 295
#define BRACKETS 296
#define WORD 297
#define STRING_LITERAL 298
#define PRIMETYPE 299
#define INTEGER_LITERAL 300

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 601 "parser.y"

	int num;
	numLinkListY* numList;
	char* str;
	nonTermY term;
	arrTypeY* type;
	astY* tree;
	symY* termList;
	statementY* statem;
	strArrY* strarr;

#line 816 "y.tab.c"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */



#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE
# if (defined __GNUC__                                               \
      && (2 < __GNUC__ || (__GNUC__ == 2 && 96 <= __GNUC_MINOR__)))  \
     || defined __SUNPRO_C && 0x5110 <= __SUNPRO_C
#  define YY_ATTRIBUTE(Spec) __attribute__(Spec)
# else
#  define YY_ATTRIBUTE(Spec) /* empty */
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# define YY_ATTRIBUTE_PURE   YY_ATTRIBUTE ((__pure__))
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# define YY_ATTRIBUTE_UNUSED YY_ATTRIBUTE ((__unused__))
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && ! defined __ICC && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN \
    _Pragma ("GCC diagnostic push") \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")\
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif


#define YY_ASSERT(E) ((void) (0 && (E)))

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYSIZE_T yynewbytes;                                            \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / sizeof (*yyptr);                          \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYSIZE_T yyi;                         \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  6
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   220

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  46
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  32
/* YYNRULES -- Number of rules.  */
#define YYNRULES  84
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  191

#define YYUNDEFTOK  2
#define YYMAXUTOK   300

/* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, with out-of-bounds checking.  */
#define YYTRANSLATE(YYX)                                                \
  ((unsigned) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   628,   628,   632,   638,   639,   643,   647,   648,   652,
     656,   657,   661,   663,   669,   670,   674,   678,   684,   692,
     698,   705,   709,   710,   714,   715,   718,   723,   726,   727,
     731,   736,   742,   746,   749,   756,   763,   767,   771,   777,
     781,   782,   787,   788,   792,   801,   817,   818,   819,   823,
     824,   825,   829,   834,   840,   846,   847,   851,   852,   853,
     856,   859,   862,   865,   866,   867,   871,   874,   881,   885,
     886,   887,   888,   889,   890,   891,   892,   893,   897,   898,
     899,   905,   907,   909,   913
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "AND", "OR", "LESS", "GREAT", "LESSEQ",
  "GREATEQ", "EQUAL", "NOTEQUAL", "PLUS", "MINUS", "STAR", "SLASH",
  "LBRACK", "RBRACK", "LBRACE", "RBRACE", "LPARENTH", "RPARENTH",
  "EXTENDS", "HEADER", "CLASS", "IF", "WHILE", "NOT", "TRUE", "FALSE",
  "PUBLIC", "COMMA", "EQUIVALENT", "SEMICOLON", "PRINT", "PRINTLN", "DOT",
  "NEW", "THIS", "RETURN", "LENGTH", "ELSE", "BRACKETS", "WORD",
  "STRING_LITERAL", "PRIMETYPE", "INTEGER_LITERAL", "$accept", "Program",
  "MainClass", "ClassDeclList", "ClassDecl", "ParentMaybe", "Parent",
  "VarMethodDeclList", "VarOrMethod", "VarMethodDecl", "VarDecl",
  "VarInitList", "VarInit", "MethodDecl", "FormalListMaybe", "FormalList",
  "Type", "BracketsList", "StatementList", "Statement", "MethodCall",
  "LeftValue", "LeftValue2", "IndexList", "Index", "ExpList", "ExpOp",
  "NewFunc", "ExpP2", "ExpP", "Exp", "id", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300
};
# endif

#define YYPACT_NINF -90

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-90)))

#define YYTABLE_NINF -85

#define yytable_value_is_error(Yytable_value) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
      16,    14,    54,    38,   -90,    46,   -90,    14,   -90,    38,
      44,    52,   -90,    57,    14,    90,   -90,    50,   -90,    26,
      80,     1,   -90,   104,    26,    83,   -90,    14,   102,    82,
     -90,   -90,    22,    82,   130,   134,   -90,   140,     1,   -90,
     -90,   114,   128,   -90,   148,   -90,   140,   140,   -90,   -90,
       1,   138,   -90,   -90,   -90,   -90,    18,   -90,   139,   126,
      77,   141,   -90,    14,   -90,   136,   118,    77,    81,   -90,
     154,   160,    14,   140,   144,   -21,    14,   140,   140,   140,
     140,   140,   140,   140,   140,   140,   140,   167,   158,   183,
     118,   157,   175,   176,   177,   178,    14,   140,    63,   156,
     182,   118,   169,    -5,     7,   139,   140,   140,   -90,   140,
     184,   -90,   -90,    48,   -90,    27,    98,   -90,   -90,   -90,
     -90,   -90,   -90,   -90,   -90,   -90,   -90,   -90,   126,   126,
     118,     1,   -90,   185,   186,   140,   140,   140,   140,   160,
       0,   183,   187,   -90,   -90,   140,    14,   140,   140,    14,
      77,    77,   -90,   192,   -90,   -90,   -90,   140,   190,   -90,
     -90,   174,    91,   127,   129,   179,   -90,   -90,   -90,    12,
      40,   -90,   -90,   140,    98,   -90,    14,   118,   118,   170,
     180,   -90,   -90,   -90,   -90,   171,   -90,   -90,   -90,   118,
     -90
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       0,     0,     0,     5,    84,     0,     1,     0,     2,     5,
       0,     8,     4,     0,     0,     0,     7,     0,     9,    11,
       0,     0,    29,     0,    11,     0,    29,     0,     0,    26,
       6,    10,    20,    27,     0,     0,    28,     0,    23,    12,
      14,     0,    17,    15,     0,    13,     0,     0,    60,    61,
       0,     0,    44,    59,    62,    63,    66,    77,    64,    80,
      19,     0,    22,     0,    16,     0,    31,    83,     0,    57,
       0,    29,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    24,    20,
      31,     0,     0,     0,     0,     0,     0,     0,    44,     0,
       0,    31,     0,     0,     0,     0,     0,     0,    58,     0,
       0,    48,    45,     0,    43,     0,    55,    67,    46,    47,
      69,    70,    71,    72,    73,    74,    76,    75,    78,    79,
      31,     0,    18,     0,     0,     0,     0,     0,     0,     0,
       0,    20,     0,    30,    41,     0,     0,     0,     0,     0,
      81,    82,    65,    53,    68,    54,    42,     0,     0,    25,
      33,     0,     0,     0,     0,     0,    40,    32,     3,     0,
       0,    49,    50,     0,    56,    21,     0,     0,     0,     0,
       0,    38,    39,    52,    51,     0,    35,    37,    36,     0,
      34
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
     -90,   -90,   -90,   201,   -90,   -90,   -90,   189,   -90,   -90,
      73,   131,   -90,   181,   -90,    84,    -4,   195,   -82,   -89,
     -65,   -61,   -90,    45,   -71,   -90,     3,   -63,    34,   -28,
     -39,    -1
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     2,     3,     8,     9,    15,    16,    23,    24,    39,
      40,    41,    42,    43,    61,    62,    99,    33,   100,   101,
      55,    56,   104,   152,   153,   115,    57,    58,    59,    67,
     113,    26
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
       5,   102,   112,   105,   145,   103,    11,    68,   133,    60,
      73,   106,   107,    18,    74,    25,   147,    28,   117,   143,
      25,     4,   148,   106,   107,   102,    34,   105,   134,   103,
     146,    37,   166,    73,    63,   116,   102,    74,   105,     1,
     103,    38,   149,     4,   181,    22,    70,   156,   158,    71,
      69,   106,   107,    75,     6,    21,     4,   157,   140,   106,
     107,     7,    88,    10,   155,   102,    13,   105,     4,   103,
      22,   111,   182,    14,   118,   119,    17,   171,   150,   151,
     120,   121,   122,   123,   124,   125,   126,   127,   185,   186,
      85,    86,   106,   107,    20,   139,   162,   163,   164,   165,
     190,   108,   106,   107,   -84,   -84,   169,    19,   170,   106,
     107,   177,   102,   102,   105,   105,   103,   103,   174,   128,
     129,    27,    30,    36,   102,    32,   105,    63,   103,    77,
      78,    79,    80,    81,    82,    90,    83,    91,   106,   107,
     106,   107,    92,    93,    35,   118,    64,   178,   172,   179,
      44,    94,    95,    38,    96,    51,    97,    84,    65,    46,
      98,    87,    22,    46,   114,    66,    47,    48,    49,   109,
      47,    48,    49,    72,    76,   184,    50,    51,    89,   110,
      50,    51,    52,    53,   130,    54,    52,    53,   131,    54,
     106,   107,    37,    96,   135,   136,   137,   138,   141,   180,
     142,   144,   187,   160,   154,   168,   161,   173,   175,   176,
      12,   189,   188,    31,   167,   159,    45,    29,   183,     0,
     132
};

static const yytype_int16 yycheck[] =
{
       1,    66,    73,    66,     9,    66,     7,    46,    90,    37,
      15,    11,    12,    14,    19,    19,     9,    21,    39,   101,
      24,    42,    15,    11,    12,    90,    27,    90,    91,    90,
      35,     9,    32,    15,    38,    74,   101,    19,   101,    23,
     101,    19,    35,    42,    32,    44,    50,    20,   130,    50,
      47,    11,    12,    35,     0,    29,    42,    30,    97,    11,
      12,    23,    63,    17,    16,   130,    22,   130,    42,   130,
      44,    72,    32,    21,    75,    76,    19,   148,   106,   107,
      77,    78,    79,    80,    81,    82,    83,    84,   177,   178,
      13,    14,    11,    12,    44,    96,   135,   136,   137,   138,
     189,    20,    11,    12,    41,    42,   145,    17,   147,    11,
      12,    20,   177,   178,   177,   178,   177,   178,   157,    85,
      86,    41,    18,    41,   189,    42,   189,   131,   189,     3,
       4,     5,     6,     7,     8,    17,    10,    19,    11,    12,
      11,    12,    24,    25,    42,   146,    32,    20,   149,    20,
      20,    33,    34,    19,    36,    37,    38,    31,    30,    19,
      42,    20,    44,    19,    20,    17,    26,    27,    28,    15,
      26,    27,    28,    35,    35,   176,    36,    37,    42,    19,
      36,    37,    42,    43,    17,    45,    42,    43,    30,    45,
      11,    12,     9,    36,    19,    19,    19,    19,    42,    20,
      18,    32,    32,    18,    20,    18,    20,    15,    18,    35,
       9,    40,    32,    24,   141,   131,    35,    22,   173,    -1,
      89
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,    23,    47,    48,    42,    77,     0,    23,    49,    50,
      17,    77,    49,    22,    21,    51,    52,    19,    77,    17,
      44,    29,    44,    53,    54,    62,    77,    41,    62,    63,
      18,    53,    42,    63,    77,    42,    41,     9,    19,    55,
      56,    57,    58,    59,    20,    59,    19,    26,    27,    28,
      36,    37,    42,    43,    45,    66,    67,    72,    73,    74,
      75,    60,    61,    62,    32,    30,    17,    75,    76,    72,
      62,    77,    35,    15,    19,    35,    35,     3,     4,     5,
       6,     7,     8,    10,    31,    13,    14,    20,    77,    42,
      17,    19,    24,    25,    33,    34,    36,    38,    42,    62,
      64,    65,    66,    67,    68,    73,    11,    12,    20,    15,
      19,    77,    70,    76,    20,    71,    76,    39,    77,    77,
      72,    72,    72,    72,    72,    72,    72,    72,    74,    74,
      17,    30,    57,    64,    73,    19,    19,    19,    19,    77,
      76,    42,    18,    64,    32,     9,    35,     9,    15,    35,
      75,    75,    69,    70,    20,    16,    20,    30,    64,    61,
      18,    20,    76,    76,    76,    76,    32,    56,    18,    76,
      76,    70,    77,    15,    76,    18,    35,    20,    20,    20,
      20,    32,    32,    69,    77,    65,    65,    32,    32,    40,
      65
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    46,    47,    48,    49,    49,    50,    51,    51,    52,
      53,    53,    54,    54,    55,    55,    56,    57,    57,    58,
      58,    59,    60,    60,    61,    61,    62,    62,    63,    63,
      64,    64,    65,    65,    65,    65,    65,    65,    65,    65,
      65,    65,    66,    66,    67,    67,    67,    67,    67,    68,
      68,    68,    69,    69,    70,    71,    71,    72,    72,    72,
      72,    72,    72,    72,    72,    72,    72,    72,    73,    74,
      74,    74,    74,    74,    74,    74,    74,    74,    75,    75,
      75,    76,    76,    76,    77
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     2,    13,     2,     0,     6,     1,     0,     2,
       2,     0,     3,     4,     1,     1,     2,     1,     4,     2,
       0,     6,     1,     0,     2,     4,     2,     2,     2,     0,
       2,     0,     3,     3,     7,     5,     5,     5,     4,     4,
       3,     2,     4,     3,     1,     3,     3,     3,     3,     3,
       3,     5,     3,     1,     2,     1,     3,     2,     3,     1,
       1,     1,     1,     1,     1,     4,     1,     3,     4,     3,
       3,     3,     3,     3,     3,     3,     3,     1,     3,     3,
       1,     3,     3,     1,     1
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                    \
  do                                                              \
    if (yychar == YYEMPTY)                                        \
      {                                                           \
        yychar = (Token);                                         \
        yylval = (Value);                                         \
        YYPOPSTACK (yylen);                                       \
        yystate = *yyssp;                                         \
        goto yybackup;                                            \
      }                                                           \
    else                                                          \
      {                                                           \
        yyerror (YY_("syntax error: cannot back up")); \
        YYERROR;                                                  \
      }                                                           \
  while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyoutput = yyo;
  YYUSE (yyoutput);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyo, yytoknum[yytype], *yyvaluep);
# endif
  YYUSE (yytype);
}


/*---------------------------.
| Print this symbol on YYO.  |
`---------------------------*/

static void
yy_symbol_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyo, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyo, yytype, yyvaluep);
  YYFPRINTF (yyo, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yytype_int16 *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  unsigned long yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[yyssp[yyi + 1 - yynrhs]],
                       &yyvsp[(yyi + 1) - (yynrhs)]
                                              );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
static YYSIZE_T
yystrlen (const char *yystr)
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            else
              goto append;

          append:
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return (YYSIZE_T) (yystpcpy (yyres, yystr) - yyres);
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                yytype_int16 *yyssp, int yytoken)
{
  YYSIZE_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
  YYSIZE_T yysize = yysize0;
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat. */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Number of reported tokens (one for the "unexpected", one per
     "expected"). */
  int yycount = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[*yyssp];
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
                    yysize = yysize1;
                  else
                    return 2;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
    default: /* Avoid compiler warnings. */
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
    if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
      yysize = yysize1;
    else
      return 2;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          yyp++;
          yyformat++;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;


/*------------------------------------------------------------.
| yynewstate -- push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;


/*--------------------------------------------------------------------.
| yynewstate -- set current state (the top of the stack) to yystate.  |
`--------------------------------------------------------------------*/
yysetstate:
  YYDPRINTF ((stderr, "Entering state %d\n", yystate));
  YY_ASSERT (0 <= yystate && yystate < YYNSTATES);
  *yyssp = (yytype_int16) yystate;

  if (yyss + yystacksize - 1 <= yyssp)
#if !defined yyoverflow && !defined YYSTACK_RELOCATE
    goto yyexhaustedlab;
#else
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = (YYSIZE_T) (yyssp - yyss + 1);

# if defined yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        YYSTYPE *yyvs1 = yyvs;
        yytype_int16 *yyss1 = yyss;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * sizeof (*yyssp),
                    &yyvs1, yysize * sizeof (*yyvsp),
                    &yystacksize);
        yyss = yyss1;
        yyvs = yyvs1;
      }
# else /* defined YYSTACK_RELOCATE */
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yytype_int16 *yyss1 = yyss;
        union yyalloc *yyptr =
          (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
# undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
                  (unsigned long) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }
#endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;


/*-----------.
| yybackup.  |
`-----------*/
yybackup:
  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
  case 3:
#line 632 "parser.y"
    {
		execStatement((statement*)(yyvsp[-2].statem));
	}
#line 2050 "y.tab.c"
    break;

  case 12:
#line 661 "parser.y"
    {			//DO INSERTIONS HERE***
	}
#line 2057 "y.tab.c"
    break;

  case 13:
#line 663 "parser.y"
    {
	 
	}
#line 2065 "y.tab.c"
    break;

  case 14:
#line 669 "parser.y"
    {(yyval.termList) = (yyvsp[0].termList);}
#line 2071 "y.tab.c"
    break;

  case 16:
#line 674 "parser.y"
    {(yyval.termList) = (yyvsp[-1].termList);}
#line 2077 "y.tab.c"
    break;

  case 17:
#line 678 "parser.y"
    {
		/*symY* var = malloc(sizeof(symY));
		var->term = &$1;
		$$ = var;*/
		(yyval.termList) = (yyvsp[0].termList);
	}
#line 2088 "y.tab.c"
    break;

  case 18:
#line 684 "parser.y"
    {
		(yyvsp[0].termList)->name = (yyvsp[-1].str);
		(yyvsp[-3].termList)->next = (yyvsp[0].termList);
		(yyval.termList) = (yyvsp[-3].termList);
	}
#line 2098 "y.tab.c"
    break;

  case 19:
#line 692 "parser.y"
    {
		//$$ = *(nonTermY*)solveAst((ast*)$2);
		symY* var = malloc(sizeof(symY));
		var->term = (nonTermY*)solveAst((ast*)(yyvsp[0].tree));
		(yyval.termList) = var;
	}
#line 2109 "y.tab.c"
    break;

  case 20:
#line 698 "parser.y"
    {
		symY* var = malloc(sizeof(symY));
		(yyval.termList) = var;
	}
#line 2118 "y.tab.c"
    break;

  case 21:
#line 705 "parser.y"
    {}
#line 2124 "y.tab.c"
    break;

  case 26:
#line 718 "parser.y"
    {
		(yyval.type) = malloc(sizeof(arrTypeY));
		(yyval.type)->type = setType((yyvsp[-1].str));
		(yyval.type)->deg = (yyvsp[0].num);
	}
#line 2134 "y.tab.c"
    break;

  case 27:
#line 723 "parser.y"
    {}
#line 2140 "y.tab.c"
    break;

  case 28:
#line 726 "parser.y"
    {(yyval.num)++;}
#line 2146 "y.tab.c"
    break;

  case 29:
#line 727 "parser.y"
    {(yyval.num) = 1;}
#line 2152 "y.tab.c"
    break;

  case 30:
#line 731 "parser.y"
    {
		//execStatement((statement*)$2);
		(yyvsp[-1].statem)->next = (yyvsp[0].statem);
		(yyval.statem) = (yyvsp[-1].statem);	
	}
#line 2162 "y.tab.c"
    break;

  case 31:
#line 736 "parser.y"
    {
		(yyval.statem) = NULL;	//this needs to be here
	}
#line 2170 "y.tab.c"
    break;

  case 32:
#line 742 "parser.y"
    {
		statement* statem = mkStatement(DECLY, NULL, (yyvsp[-1].str), NULL, NULL, (arrType*)(yyvsp[-2].type), (sym*)(yyvsp[0].termList));
		(yyval.statem) = (statementY*)statem;
	}
#line 2179 "y.tab.c"
    break;

  case 33:
#line 746 "parser.y"
    {
		(yyval.statem) = (yyvsp[-1].statem);
	}
#line 2187 "y.tab.c"
    break;

  case 34:
#line 749 "parser.y"
    {
		statement* statem = mkStatement(IFELSEY, NULL, NULL, NULL, NULL, NULL, NULL);
		statem->conditional = (ast*)(yyvsp[-4].tree);
		statem->sub1 = (statement*)(yyvsp[-2].statem);
		statem->sub2 = (statement*)(yyvsp[0].statem);
		(yyval.statem) = (statementY*)statem;		
	}
#line 2199 "y.tab.c"
    break;

  case 35:
#line 756 "parser.y"
    {	//This guy adds an extra null statement that gets checked
		statement* statem = mkStatement(WHILENY, NULL, NULL, NULL, NULL, NULL, NULL);		
		statem->conditional = (ast*)(yyvsp[-2].tree);
		statem->sub1 = (statement*)(yyvsp[0].statem);
		(yyval.statem) = (statementY*)statem;
		
	}
#line 2211 "y.tab.c"
    break;

  case 36:
#line 763 "parser.y"
    {
		statement* statem = mkStatement(PRINTNLINE, NULL, NULL, NULL, (ast*)(yyvsp[-2].tree), NULL, NULL);
		(yyval.statem) = (statementY*)statem;
	}
#line 2220 "y.tab.c"
    break;

  case 37:
#line 767 "parser.y"
    {
		statement* statem = mkStatement(PRINTN, NULL, NULL, NULL, (ast*)(yyvsp[-2].tree), NULL, NULL);
		(yyval.statem) = (statementY*)statem;
	}
#line 2229 "y.tab.c"
    break;

  case 38:
#line 771 "parser.y"
    {
		//$1->term = (nonTermY*)solveAst((ast*)$3);
		statement* statem = mkStatement(INIT, NULL, NULL, (strArr*)(yyvsp[-3].strarr), (ast*)(yyvsp[-1].tree), NULL, NULL);
		(yyval.statem) = (statementY*)statem;
		//memcpy((void*)$1->term, (void*)(solveAst((ast*)$3)), sizeof(nonTerm));	//lol
	}
#line 2240 "y.tab.c"
    break;

  case 39:
#line 777 "parser.y"
    {
		statement* statem = mkStatement(INIT, NULL, NULL, (strArr*)(yyvsp[-3].strarr), (ast*)(yyvsp[-1].tree), NULL, NULL);
		(yyval.statem) = (statementY*)statem;
	}
#line 2249 "y.tab.c"
    break;

  case 40:
#line 781 "parser.y"
    {}
#line 2255 "y.tab.c"
    break;

  case 41:
#line 782 "parser.y"
    {}
#line 2261 "y.tab.c"
    break;

  case 42:
#line 787 "parser.y"
    {}
#line 2267 "y.tab.c"
    break;

  case 43:
#line 788 "parser.y"
    {}
#line 2273 "y.tab.c"
    break;

  case 44:
#line 792 "parser.y"
    {
		//if(search($1)!=NULL)
			strArrY* this = malloc(sizeof(strArrY));
			this->str = (yyvsp[0].str);
			(yyval.strarr) = this;
			//$$ = (symY *)search($1);
		//else
		//	typeViolation();
	}
#line 2287 "y.tab.c"
    break;

  case 45:
#line 801 "parser.y"
    {
		if((yyvsp[-2].strarr)->num == NULL){		//first deg of array
			(yyvsp[-2].strarr)->num = malloc(sizeof(numLinkListY));
			(yyvsp[-2].strarr)->num->num = (yyvsp[0].tree);
		} else {

		numLinkListY* current = (yyvsp[-2].strarr)->num;
		while(current->next!=NULL)
			current = current->next;	//points to tail

		current->next = malloc(sizeof(numLinkListY));
		current->next->num = (yyvsp[0].tree);
	
		}
		(yyval.strarr) = (yyvsp[-2].strarr);
	}
#line 2308 "y.tab.c"
    break;

  case 46:
#line 817 "parser.y"
    {}
#line 2314 "y.tab.c"
    break;

  case 47:
#line 818 "parser.y"
    {}
#line 2320 "y.tab.c"
    break;

  case 48:
#line 819 "parser.y"
    {}
#line 2326 "y.tab.c"
    break;

  case 52:
#line 829 "parser.y"
    {
		(yyval.numList) = malloc(sizeof(numLinkListY));
		(yyval.numList)->num = (yyvsp[-2].tree);
		(yyval.numList)->next = (yyvsp[0].numList);	
	}
#line 2336 "y.tab.c"
    break;

  case 53:
#line 834 "parser.y"
    {
		(yyval.numList) = malloc(sizeof(numLinkListY));
		(yyval.numList)->num = (yyvsp[0].tree);
	}
#line 2345 "y.tab.c"
    break;

  case 54:
#line 840 "parser.y"
    {
		(yyval.tree) = (yyvsp[-1].tree);
	}
#line 2353 "y.tab.c"
    break;

  case 57:
#line 851 "parser.y"
    {}
#line 2359 "y.tab.c"
    break;

  case 58:
#line 852 "parser.y"
    {(yyval.tree) = (yyvsp[-1].tree);}
#line 2365 "y.tab.c"
    break;

  case 59:
#line 853 "parser.y"
    {
		(yyval.tree) = (astY*)mkLeaf(mkNonTerm(STRINGY, (void*)(yyvsp[0].str)));
	}
#line 2373 "y.tab.c"
    break;

  case 60:
#line 856 "parser.y"
    {
		(yyval.tree) = (astY*)mkLeaf(mkNonTerm(BOOLY, (void*)&(yyvsp[0].num)));
	}
#line 2381 "y.tab.c"
    break;

  case 61:
#line 859 "parser.y"
    {
		(yyval.tree) = (astY*)mkLeaf(mkNonTerm(BOOLY, (void*)&(yyvsp[0].num)));
	}
#line 2389 "y.tab.c"
    break;

  case 62:
#line 862 "parser.y"
    {
		(yyval.tree) = (astY*)mkLeaf(mkNonTerm(INTY, (void*)&(yyvsp[0].num)));
	}
#line 2397 "y.tab.c"
    break;

  case 63:
#line 865 "parser.y"
    {}
#line 2403 "y.tab.c"
    break;

  case 64:
#line 866 "parser.y"
    {}
#line 2409 "y.tab.c"
    break;

  case 65:
#line 867 "parser.y"
    {		//CREATE ENTIRE ARRAY USING LIST OF INT
		(yyval.tree) = (astY*)mkLeaf((nonTerm*) mkNonTermArr((varType)(yyvsp[-2].type)->type, (numLinkList*)(yyvsp[0].numList)));	//***	

	}
#line 2418 "y.tab.c"
    break;

  case 66:
#line 871 "parser.y"
    {
		if((yyvsp[0].strarr)!=NULL){(yyval.tree) = (astY*)mkLeafStr((strArr*)(yyvsp[0].strarr));}
	}
#line 2426 "y.tab.c"
    break;

  case 67:
#line 874 "parser.y"
    {}
#line 2432 "y.tab.c"
    break;

  case 68:
#line 881 "parser.y"
    {}
#line 2438 "y.tab.c"
    break;

  case 69:
#line 885 "parser.y"
    {(yyval.tree) = (astY*)mkNode((ast*)(yyvsp[-2].tree), (ast*)(yyvsp[0].tree), ANDY);}
#line 2444 "y.tab.c"
    break;

  case 70:
#line 886 "parser.y"
    {(yyval.tree) = (astY*)mkNode((ast*)(yyvsp[-2].tree), (ast*)(yyvsp[0].tree), ORY);}
#line 2450 "y.tab.c"
    break;

  case 71:
#line 887 "parser.y"
    {(yyval.tree) = (astY*)mkNode((ast*)(yyvsp[-2].tree), (ast*)(yyvsp[0].tree), LESSY);}
#line 2456 "y.tab.c"
    break;

  case 72:
#line 888 "parser.y"
    {(yyval.tree) = (astY*)mkNode((ast*)(yyvsp[-2].tree), (ast*)(yyvsp[0].tree), GREATY);}
#line 2462 "y.tab.c"
    break;

  case 73:
#line 889 "parser.y"
    {(yyval.tree) = (astY*)mkNode((ast*)(yyvsp[-2].tree), (ast*)(yyvsp[0].tree), LESSEQY);}
#line 2468 "y.tab.c"
    break;

  case 74:
#line 890 "parser.y"
    {(yyval.tree) = (astY*)mkNode((ast*)(yyvsp[-2].tree), (ast*)(yyvsp[0].tree), GREATEQY);}
#line 2474 "y.tab.c"
    break;

  case 75:
#line 891 "parser.y"
    {(yyval.tree) = (astY*)mkNode((ast*)(yyvsp[-2].tree), (ast*)(yyvsp[0].tree), EQUIVALENTY);}
#line 2480 "y.tab.c"
    break;

  case 76:
#line 892 "parser.y"
    {(yyval.tree) = (astY*)mkNode((ast*)(yyvsp[-2].tree), (ast*)(yyvsp[0].tree), NOTEQUALY);}
#line 2486 "y.tab.c"
    break;

  case 77:
#line 893 "parser.y"
    {(yyval.tree) = (yyvsp[0].tree);}
#line 2492 "y.tab.c"
    break;

  case 78:
#line 897 "parser.y"
    {(yyval.tree) = (astY*)mkNode((ast*)(yyvsp[-2].tree), (ast*)(yyvsp[0].tree), STARY);}
#line 2498 "y.tab.c"
    break;

  case 79:
#line 898 "parser.y"
    {(yyval.tree) = (astY*)mkNode((ast*)(yyvsp[-2].tree), (ast*)(yyvsp[0].tree), SLASHY);}
#line 2504 "y.tab.c"
    break;

  case 80:
#line 899 "parser.y"
    {(yyval.tree) = (yyvsp[0].tree);}
#line 2510 "y.tab.c"
    break;

  case 81:
#line 905 "parser.y"
    {(yyval.tree) = (astY*)mkNode((ast*)(yyvsp[-2].tree), (ast*)(yyvsp[0].tree), PLUSY);}
#line 2516 "y.tab.c"
    break;

  case 82:
#line 907 "parser.y"
    {(yyval.tree) = (astY*)mkNode((ast*)(yyvsp[-2].tree), (ast*)(yyvsp[0].tree), MINUSY);}
#line 2522 "y.tab.c"
    break;

  case 83:
#line 909 "parser.y"
    {(yyval.tree) = (yyvsp[0].tree);}
#line 2528 "y.tab.c"
    break;

  case 84:
#line 913 "parser.y"
    {
		if(search((yyvsp[0].str))!=NULL){
			memcpy((void*)&(yyval.term), (void*)search((yyvsp[0].str))->term, sizeof(nonTerm));
		} else{		//do something if not declared yet, idk what
		}
	}
#line 2539 "y.tab.c"
    break;


#line 2543 "y.tab.c"

      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */
  {
    const int yylhs = yyr1[yyn] - YYNTOKENS;
    const int yyi = yypgoto[yylhs] + *yyssp;
    yystate = (0 <= yyi && yyi <= YYLAST && yycheck[yyi] == *yyssp
               ? yytable[yyi]
               : yydefgoto[yylhs]);
  }

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:
  /* Pacify compilers when the user code never invokes YYERROR and the
     label yyerrorlab therefore never appears in user code.  */
  if (0)
    YYERROR;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;


/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;


#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif


/*-----------------------------------------------------.
| yyreturn -- parsing is finished, return the result.  |
`-----------------------------------------------------*/
yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
