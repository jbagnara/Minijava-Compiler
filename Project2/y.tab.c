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
	//printall();	
}


#line 140 "y.tab.c"

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
    PRIMETYPE = 284,
    PUBLIC = 285,
    COMMA = 286,
    EQUIVALENT = 287,
    SEMICOLON = 288,
    PRINT = 289,
    PRINTLN = 290,
    DOT = 291,
    NEW = 292,
    THIS = 293,
    RETURN = 294,
    LENGTH = 295,
    ELSE = 296,
    BRACKETS = 297,
    WORD = 298,
    STRING_LITERAL = 299,
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
#define PRIMETYPE 284
#define PUBLIC 285
#define COMMA 286
#define EQUIVALENT 287
#define SEMICOLON 288
#define PRINT 289
#define PRINTLN 290
#define DOT 291
#define NEW 292
#define THIS 293
#define RETURN 294
#define LENGTH 295
#define ELSE 296
#define BRACKETS 297
#define WORD 298
#define STRING_LITERAL 299
#define INTEGER_LITERAL 300

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 72 "parser.y"

	int num;
	char* str;

#line 278 "y.tab.c"

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
#define YYLAST   460

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  46
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  30
/* YYNRULES -- Number of rules.  */
#define YYNRULES  86
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  198

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
static const yytype_uint8 yyrline[] =
{
       0,    86,    86,    90,    94,    95,    99,   103,   104,   108,
     112,   113,   117,   118,   123,   124,   128,   132,   133,   137,
     138,   142,   146,   147,   151,   152,   155,   156,   159,   160,
     164,   165,   169,   170,   171,   172,   173,   174,   175,   176,
     177,   178,   179,   180,   185,   186,   190,   191,   192,   193,
     194,   197,   198,   199,   200,   203,   204,   207,   211,   212,
     216,   217,   219,   220,   221,   222,   223,   224,   225,   226,
     227,   228,   232,   236,   237,   238,   239,   240,   241,   242,
     243,   244,   245,   246,   247,   248,   252
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
  "PRIMETYPE", "PUBLIC", "COMMA", "EQUIVALENT", "SEMICOLON", "PRINT",
  "PRINTLN", "DOT", "NEW", "THIS", "RETURN", "LENGTH", "ELSE", "BRACKETS",
  "WORD", "STRING_LITERAL", "INTEGER_LITERAL", "$accept", "Program",
  "MainClass", "ClassDeclList", "ClassDecl", "ParentMaybe", "Parent",
  "VarMethodDeclList", "VarOrMethod", "VarMethodDecl", "VarDecl",
  "VarInitList", "VarInit", "MethodDecl", "FormalListMaybe", "FormalList",
  "Type", "BracketsList", "StatementList", "Statement", "MethodCall",
  "LeftValue", "LeftValue2", "IndexList", "Index", "ExpList", "ExpOp",
  "NewFunc", "Exp", "id", YY_NULLPTR
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

#define YYPACT_NINF -162

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-162)))

#define YYTABLE_NINF -87

#define yytable_value_is_error(Yytable_value) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
      -5,   -22,    27,    14,  -162,    36,  -162,   -22,  -162,    14,
      32,    50,  -162,    38,   -22,    56,  -162,    51,  -162,    26,
      39,  -162,   -20,    64,    26,    40,  -162,   -22,    42,    46,
    -162,  -162,    -7,    42,    65,  -162,    71,   182,   -20,  -162,
    -162,    58,    61,  -162,    80,  -162,   182,   182,   182,   182,
    -162,  -162,   -20,    63,  -162,  -162,  -162,    31,  -162,    72,
     395,    81,  -162,   -22,  -162,    57,   394,  -162,  -162,   192,
    -162,    88,    90,   -22,   182,    67,   -26,   -22,   182,   182,
     182,   182,   182,   182,   182,   182,   182,   182,   182,   182,
      94,    76,   104,   394,    77,   100,   105,   106,   111,   -22,
     182,    18,    89,   116,   394,   102,    87,     7,    72,  -162,
     182,   121,  -162,  -162,   280,  -162,    11,   395,  -162,  -162,
    -162,  -162,  -162,  -162,  -162,  -162,  -162,  -162,  -162,  -162,
    -162,  -162,  -162,   394,   -20,  -162,   124,   123,   182,   182,
      21,   128,    90,   225,   104,   126,  -162,  -162,   182,   -22,
     182,   182,   -22,   130,  -162,  -162,  -162,  -162,   182,   135,
    -162,  -162,   122,   303,   326,   137,   349,   139,   372,  -162,
    -162,  -162,   237,   268,  -162,  -162,   182,   395,  -162,   -22,
     417,   417,   127,   129,   131,   134,  -162,  -162,  -162,  -162,
     120,  -162,  -162,  -162,  -162,  -162,   417,  -162
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       0,     0,     0,     5,    86,     0,     1,     0,     2,     5,
       0,     8,     4,     0,     0,     0,     7,     0,     9,    11,
       0,    29,     0,     0,    11,     0,    29,     0,    26,     0,
       6,    10,    20,    27,     0,    28,     0,     0,    23,    12,
      14,     0,    17,    15,     0,    13,     0,     0,     0,     0,
      62,    63,     0,     0,    46,    64,    65,    68,    85,    66,
      19,     0,    22,     0,    16,     0,    51,    70,    71,     0,
      60,     0,    29,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    24,    20,    51,     0,     0,     0,     0,     0,     0,
       0,    46,     0,     0,    51,     0,     0,     0,     0,    61,
       0,     0,    50,    47,     0,    45,     0,    58,    69,    48,
      49,    73,    74,    75,    76,    77,    78,    80,    83,    84,
      81,    82,    79,    51,     0,    18,     0,     0,     0,     0,
       0,     0,     0,     0,    20,     0,    30,    43,     0,     0,
       0,     0,     0,    67,    56,    72,    57,    44,     0,     0,
      25,    33,     0,     0,     0,     0,     0,     0,     0,    42,
      32,     3,     0,     0,    52,    53,     0,    59,    21,     0,
      51,    51,     0,     0,     0,     0,    40,    41,    55,    54,
       0,    35,    38,    39,    37,    36,    51,    34
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -162,  -162,  -162,   154,  -162,  -162,  -162,   144,  -162,  -162,
      25,    78,  -162,   138,  -162,    41,   -14,   155,   -89,  -161,
     -63,   -59,  -162,  -162,   -99,  -162,   103,   -65,   -12,    -1
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     2,     3,     8,     9,    15,    16,    23,    24,    39,
      40,    41,    42,    43,    61,    62,   102,    33,   103,   104,
      56,    57,   107,   153,   113,   116,    58,    59,   114,    26
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
       5,   108,    37,   105,   136,    25,    11,   106,    29,    21,
      25,   154,    38,    18,   118,   146,   150,     4,     1,   190,
     191,     4,   151,     4,    63,    60,    34,     6,   108,   137,
     105,   157,    46,    47,   106,   197,    69,     7,    71,   108,
      48,   105,   158,   152,   159,   106,    74,    49,    50,    51,
      75,    72,   174,    10,    13,    21,    22,    17,    52,    53,
     -86,   -86,    91,   117,    54,   165,    55,    76,   108,     4,
     105,    14,   112,    19,   106,   119,   120,   188,    46,    47,
      20,    27,    30,    32,    35,    44,    48,   115,   143,    36,
      38,    64,    65,    49,    50,    51,   148,    66,   142,    73,
      92,    90,    74,   110,    52,    53,    75,   134,    77,   111,
      54,   133,    55,    37,    99,   108,   108,   105,   105,   138,
      63,   106,   106,   149,   139,   140,   163,   164,   166,   168,
     141,   108,   144,   105,   145,   147,   172,   106,   173,    46,
      47,   155,   161,   162,   171,   176,   177,    48,   119,    67,
      68,   175,    70,   178,    49,    50,    51,   182,   179,   184,
     192,   196,   193,    12,   194,    52,    53,   195,    31,   170,
     135,    54,   167,    55,    45,   160,    28,     0,   189,     0,
       0,   121,   122,   123,   124,   125,   126,   127,   128,   129,
     130,   131,   132,    46,    47,    78,    79,    80,    81,    82,
      83,    48,    84,    85,    86,    87,    88,     0,    49,    50,
      51,     0,   109,     0,     0,     0,     0,     0,     0,    52,
      53,     0,     0,     0,    89,    54,     0,    55,    78,    79,
      80,    81,    82,    83,     0,    84,    85,    86,    87,    88,
      78,    79,    80,    81,    82,    83,     0,    84,    85,    86,
      87,    88,     0,     0,     0,     0,     0,    89,   169,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    89,
     186,    78,    79,    80,    81,    82,    83,     0,    84,    85,
      86,    87,    88,    78,    79,    80,    81,    82,    83,     0,
      84,    85,    86,    87,    88,     0,   156,     0,     0,     0,
      89,   187,     0,     0,     0,     0,    78,    79,    80,    81,
      82,    83,    89,    84,    85,    86,    87,    88,     0,     0,
       0,     0,     0,   180,     0,     0,     0,     0,     0,    78,
      79,    80,    81,    82,    83,    89,    84,    85,    86,    87,
      88,     0,     0,     0,     0,     0,   181,     0,     0,     0,
       0,     0,    78,    79,    80,    81,    82,    83,    89,    84,
      85,    86,    87,    88,     0,     0,     0,     0,     0,   183,
       0,     0,     0,     0,     0,    78,    79,    80,    81,    82,
      83,    89,    84,    85,    86,    87,    88,     0,     0,     0,
       0,     0,   185,     0,     0,     0,     0,     0,    78,    79,
      80,    81,    82,    83,    89,    84,    85,    86,    87,    88,
       0,    93,   -31,    94,     0,     0,     0,     0,    95,    96,
       0,     0,     0,    21,     0,     0,     0,    89,    97,    98,
       0,    99,    53,   100,    93,     0,    94,   101,     0,     0,
       0,    95,    96,     0,     0,     0,    21,     0,     0,     0,
       0,    97,    98,     0,    99,    53,   100,     0,     0,     0,
     101
};

static const yytype_int16 yycheck[] =
{
       1,    66,     9,    66,    93,    19,     7,    66,    22,    29,
      24,   110,    19,    14,    40,   104,     9,    43,    23,   180,
     181,    43,    15,    43,    38,    37,    27,     0,    93,    94,
      93,    20,    11,    12,    93,   196,    48,    23,    52,   104,
      19,   104,    31,    36,   133,   104,    15,    26,    27,    28,
      19,    52,   151,    17,    22,    29,    30,    19,    37,    38,
      42,    43,    63,    75,    43,    44,    45,    36,   133,    43,
     133,    21,    73,    17,   133,    76,    77,   176,    11,    12,
      29,    42,    18,    43,    42,    20,    19,    20,   100,    43,
      19,    33,    31,    26,    27,    28,     9,    17,    99,    36,
      43,    20,    15,    15,    37,    38,    19,    31,    36,    19,
      43,    17,    45,     9,    37,   180,   181,   180,   181,    19,
     134,   180,   181,    36,    19,    19,   138,   139,   140,   141,
      19,   196,    43,   196,    18,    33,   148,   196,   150,    11,
      12,    20,    18,    20,    18,    15,   158,    19,   149,    46,
      47,   152,    49,    18,    26,    27,    28,    20,    36,    20,
      33,    41,    33,     9,    33,    37,    38,    33,    24,   144,
      92,    43,    44,    45,    36,   134,    21,    -1,   179,    -1,
      -1,    78,    79,    80,    81,    82,    83,    84,    85,    86,
      87,    88,    89,    11,    12,     3,     4,     5,     6,     7,
       8,    19,    10,    11,    12,    13,    14,    -1,    26,    27,
      28,    -1,    20,    -1,    -1,    -1,    -1,    -1,    -1,    37,
      38,    -1,    -1,    -1,    32,    43,    -1,    45,     3,     4,
       5,     6,     7,     8,    -1,    10,    11,    12,    13,    14,
       3,     4,     5,     6,     7,     8,    -1,    10,    11,    12,
      13,    14,    -1,    -1,    -1,    -1,    -1,    32,    33,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    32,
      33,     3,     4,     5,     6,     7,     8,    -1,    10,    11,
      12,    13,    14,     3,     4,     5,     6,     7,     8,    -1,
      10,    11,    12,    13,    14,    -1,    16,    -1,    -1,    -1,
      32,    33,    -1,    -1,    -1,    -1,     3,     4,     5,     6,
       7,     8,    32,    10,    11,    12,    13,    14,    -1,    -1,
      -1,    -1,    -1,    20,    -1,    -1,    -1,    -1,    -1,     3,
       4,     5,     6,     7,     8,    32,    10,    11,    12,    13,
      14,    -1,    -1,    -1,    -1,    -1,    20,    -1,    -1,    -1,
      -1,    -1,     3,     4,     5,     6,     7,     8,    32,    10,
      11,    12,    13,    14,    -1,    -1,    -1,    -1,    -1,    20,
      -1,    -1,    -1,    -1,    -1,     3,     4,     5,     6,     7,
       8,    32,    10,    11,    12,    13,    14,    -1,    -1,    -1,
      -1,    -1,    20,    -1,    -1,    -1,    -1,    -1,     3,     4,
       5,     6,     7,     8,    32,    10,    11,    12,    13,    14,
      -1,    17,    18,    19,    -1,    -1,    -1,    -1,    24,    25,
      -1,    -1,    -1,    29,    -1,    -1,    -1,    32,    34,    35,
      -1,    37,    38,    39,    17,    -1,    19,    43,    -1,    -1,
      -1,    24,    25,    -1,    -1,    -1,    29,    -1,    -1,    -1,
      -1,    34,    35,    -1,    37,    38,    39,    -1,    -1,    -1,
      43
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,    23,    47,    48,    43,    75,     0,    23,    49,    50,
      17,    75,    49,    22,    21,    51,    52,    19,    75,    17,
      29,    29,    30,    53,    54,    62,    75,    42,    63,    62,
      18,    53,    43,    63,    75,    42,    43,     9,    19,    55,
      56,    57,    58,    59,    20,    59,    11,    12,    19,    26,
      27,    28,    37,    38,    43,    45,    66,    67,    72,    73,
      74,    60,    61,    62,    33,    31,    17,    72,    72,    74,
      72,    62,    75,    36,    15,    19,    36,    36,     3,     4,
       5,     6,     7,     8,    10,    11,    12,    13,    14,    32,
      20,    75,    43,    17,    19,    24,    25,    34,    35,    37,
      39,    43,    62,    64,    65,    66,    67,    68,    73,    20,
      15,    19,    75,    70,    74,    20,    71,    74,    40,    75,
      75,    72,    72,    72,    72,    72,    72,    72,    72,    72,
      72,    72,    72,    17,    31,    57,    64,    73,    19,    19,
      19,    19,    75,    74,    43,    18,    64,    33,     9,    36,
       9,    15,    36,    69,    70,    20,    16,    20,    31,    64,
      61,    18,    20,    74,    74,    44,    74,    44,    74,    33,
      56,    18,    74,    74,    70,    75,    15,    74,    18,    36,
      20,    20,    20,    20,    20,    20,    33,    33,    70,    75,
      65,    65,    33,    33,    33,    33,    41,    65
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    46,    47,    48,    49,    49,    50,    51,    51,    52,
      53,    53,    54,    54,    55,    55,    56,    57,    57,    58,
      58,    59,    60,    60,    61,    61,    62,    62,    63,    63,
      64,    64,    65,    65,    65,    65,    65,    65,    65,    65,
      65,    65,    65,    65,    66,    66,    67,    67,    67,    67,
      67,    68,    68,    68,    68,    69,    69,    70,    71,    71,
      72,    72,    72,    72,    72,    72,    72,    72,    72,    72,
      72,    72,    73,    74,    74,    74,    74,    74,    74,    74,
      74,    74,    74,    74,    74,    74,    75
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     2,    13,     2,     0,     6,     1,     0,     2,
       2,     0,     3,     4,     1,     1,     2,     1,     4,     2,
       0,     6,     1,     0,     2,     4,     2,     2,     2,     0,
       2,     0,     3,     3,     7,     5,     5,     5,     5,     5,
       4,     4,     3,     2,     4,     3,     1,     3,     3,     3,
       3,     0,     3,     3,     5,     3,     1,     2,     1,     3,
       2,     3,     1,     1,     1,     1,     1,     4,     1,     3,
       2,     2,     4,     3,     3,     3,     3,     3,     3,     3,
       3,     3,     3,     3,     3,     1,     1
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
  case 12:
#line 117 "parser.y"
    {if(search((yyvsp[-1].str))==NULL){insert((yyvsp[-1].str));} search((yyvsp[-1].str))->value=(yyvsp[0].num);}
#line 1556 "y.tab.c"
    break;

  case 13:
#line 118 "parser.y"
    {if(search((yyvsp[-1].str))==NULL){insert((yyvsp[-1].str));} search((yyvsp[-1].str))->value=(yyvsp[0].num);}
#line 1562 "y.tab.c"
    break;

  case 14:
#line 123 "parser.y"
    {(yyval.num) = (yyvsp[0].num);}
#line 1568 "y.tab.c"
    break;

  case 16:
#line 128 "parser.y"
    {(yyval.num) = (yyvsp[-1].num);}
#line 1574 "y.tab.c"
    break;

  case 17:
#line 132 "parser.y"
    {(yyval.num) = (yyvsp[0].num);}
#line 1580 "y.tab.c"
    break;

  case 18:
#line 133 "parser.y"
    {(yyval.num) = (yyvsp[-3].num); if(search((yyvsp[-1].str))==NULL){insert((yyvsp[-1].str));} search((yyvsp[-1].str))->value = (yyvsp[0].num);}
#line 1586 "y.tab.c"
    break;

  case 19:
#line 137 "parser.y"
    {(yyval.num) = (yyvsp[0].num);}
#line 1592 "y.tab.c"
    break;

  case 20:
#line 138 "parser.y"
    {(yyval.num) = 0;}
#line 1598 "y.tab.c"
    break;

  case 32:
#line 169 "parser.y"
    {if(search((yyvsp[-1].str))==NULL){insert((yyvsp[-1].str));} search((yyvsp[-1].str))->value = (yyvsp[0].num);}
#line 1604 "y.tab.c"
    break;

  case 36:
#line 173 "parser.y"
    {printf("%d\n", (yyvsp[-2].num));}
#line 1610 "y.tab.c"
    break;

  case 37:
#line 174 "parser.y"
    {printf("%s\n", (yyvsp[-2].str));}
#line 1616 "y.tab.c"
    break;

  case 38:
#line 175 "parser.y"
    {printf("%s", (yyvsp[-2].str));}
#line 1622 "y.tab.c"
    break;

  case 39:
#line 176 "parser.y"
    {printf("%d", (yyvsp[-2].num));}
#line 1628 "y.tab.c"
    break;

  case 40:
#line 177 "parser.y"
    {search((yyvsp[-3].str))->value = (yyvsp[-1].num);}
#line 1634 "y.tab.c"
    break;

  case 46:
#line 190 "parser.y"
    {(yyval.str) = (yyvsp[0].str);}
#line 1640 "y.tab.c"
    break;

  case 60:
#line 216 "parser.y"
    {(yyval.num) = !(yyvsp[0].num);}
#line 1646 "y.tab.c"
    break;

  case 61:
#line 217 "parser.y"
    {(yyval.num) = (yyvsp[-1].num);}
#line 1652 "y.tab.c"
    break;

  case 62:
#line 219 "parser.y"
    {(yyval.num) = 1;}
#line 1658 "y.tab.c"
    break;

  case 63:
#line 220 "parser.y"
    {(yyval.num) = 0;}
#line 1664 "y.tab.c"
    break;

  case 64:
#line 221 "parser.y"
    {(yyval.num) = (yyvsp[0].num);}
#line 1670 "y.tab.c"
    break;

  case 68:
#line 225 "parser.y"
    {(yyval.num) = search((yyvsp[0].str))->value;}
#line 1676 "y.tab.c"
    break;

  case 70:
#line 227 "parser.y"
    {(yyval.num) = (yyvsp[0].num);}
#line 1682 "y.tab.c"
    break;

  case 71:
#line 228 "parser.y"
    {(yyval.num) = (yyvsp[0].num) * (-1);}
#line 1688 "y.tab.c"
    break;

  case 73:
#line 236 "parser.y"
    {(yyval.num) = (yyvsp[-2].num) && (yyvsp[0].num);}
#line 1694 "y.tab.c"
    break;

  case 74:
#line 237 "parser.y"
    {(yyval.num) = (yyvsp[-2].num) || (yyvsp[0].num);}
#line 1700 "y.tab.c"
    break;

  case 75:
#line 238 "parser.y"
    {(yyval.num) = (yyvsp[-2].num) < (yyvsp[0].num);}
#line 1706 "y.tab.c"
    break;

  case 76:
#line 239 "parser.y"
    {(yyval.num) = (yyvsp[-2].num) > (yyvsp[0].num);}
#line 1712 "y.tab.c"
    break;

  case 77:
#line 240 "parser.y"
    {(yyval.num) = (yyvsp[-2].num) <= (yyvsp[0].num);}
#line 1718 "y.tab.c"
    break;

  case 78:
#line 241 "parser.y"
    {(yyval.num) = (yyvsp[-2].num) >= (yyvsp[0].num);}
#line 1724 "y.tab.c"
    break;

  case 79:
#line 242 "parser.y"
    {(yyval.num) = (yyvsp[-2].num) == (yyvsp[0].num);}
#line 1730 "y.tab.c"
    break;

  case 80:
#line 243 "parser.y"
    {(yyval.num) = (yyvsp[-2].num) != (yyvsp[0].num);}
#line 1736 "y.tab.c"
    break;

  case 81:
#line 244 "parser.y"
    {(yyval.num) = (yyvsp[-2].num) * (yyvsp[0].num);}
#line 1742 "y.tab.c"
    break;

  case 82:
#line 245 "parser.y"
    {(yyval.num) = (yyvsp[-2].num) / (yyvsp[0].num);}
#line 1748 "y.tab.c"
    break;

  case 83:
#line 246 "parser.y"
    {(yyval.num) = (yyvsp[-2].num) + (yyvsp[0].num);}
#line 1754 "y.tab.c"
    break;

  case 84:
#line 247 "parser.y"
    {(yyval.num) = (yyvsp[-2].num) - (yyvsp[0].num);}
#line 1760 "y.tab.c"
    break;

  case 85:
#line 248 "parser.y"
    {(yyval.num) = (yyvsp[0].num);}
#line 1766 "y.tab.c"
    break;

  case 86:
#line 252 "parser.y"
    {
		if(search((yyvsp[0].str))!=NULL){
			(yyval.num) = search((yyvsp[0].str))->value;
		} else{		//do something if not declared yet, idk what
		}
	}
#line 1777 "y.tab.c"
    break;


#line 1781 "y.tab.c"

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
