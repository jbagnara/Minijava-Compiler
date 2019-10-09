/* A Bison parser, made by GNU Bison 3.4.  */

/* Bison interface for Yacc-like parsers in C

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

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

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

#line 152 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
