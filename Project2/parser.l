%{
#include <stdio.h>
#include "y.tab.h"
%}

%option yylineno

%%
"//"[^\n]*\n			//Comment
"/*"([^*]|\*+[^*/])*\*+"/"	/*Comment*/
\"[^"]*\"			return STRING_LITERAL;
[0-9]+				{yylval.num = atoi(yytext); return INTEGER_LITERAL;}
"&&"				return AND;
"||"				return OR;
"<"				return LESS;
">"				return GREAT;
"<="				return LESSEQ;
">="				return GREATEQ;
"=="				return EQUIVALENT;
"!="				return NOTEQUAL;
"="				return EQUAL;
"!"				return NOT;
"+"				return PLUS;
"-"				return MINUS;
\*				return STAR;
"/"				return SLASH;
"{"				return LBRACE;
"}"				return RBRACE;
"("				return LPARENTH;
")"				return RPARENTH;
"[]"				return BRACKETS;
"["				return LBRACK;
"]"				return RBRACK;
","				return COMMA;
"."				return DOT;
";"				return SEMICOLON;
"int"|"boolean"|"String"	return PRIMETYPE;
"public"			return PUBLIC;
"extends"			return EXTENDS;
"class"				return CLASS;
"true"				return TRUE;
"false"				return FALSE;
"new"				return NEW;
"this"				return THIS;
"return"			return RETURN;
"length"			return LENGTH;
"public static void main"	return HEADER;
"System.out.print"		return PRINT;
"System.out.println"		return PRINTLN;
"if"				return IF;
"else"				return ELSE;
"while"				return WHILE;
[a-zA-Z][a-zA-Z0-9_]*		{yylval.str=strdup(yytext); return WORD;}
\t
\n				
" "	
%%
