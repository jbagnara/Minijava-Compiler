%{
#include <stdio.h>
#include "y.tab.h"
%}

%%
\"[^"]*\"			return STRING_LITERAL;
"&&"				return AND;
"||"				return OR;
"<"				return LESS;
">"				return GREAT;
"<="				return LESSEQ;
">="				return GREATEQ;
"=="				return EQUAL;
"!="				return NOTEQUAL;
"!"				return NOT;
"+"				return PLUS;
"-"				return MINUS;
\*				return STAR;
"/"				return SLASH;
"{"				return LBRACE;
"}"				return RBRACE;
"("				return LPARENTH;
")"				return RPARENTH;
"["				return LBRACK;
"]"				return RBRACK;
"extends"			return EXTENDS;
"class"				return CLASS;
"true"				return TRUE;
"false"				return FALSE;
"public static void main"	return HEADER;
"String"|"string"		return STRINGDECL;
"if"				return IF;
"while"				return WHILE;
[a-zA-Z0-9]+			return WORD;
\t
\n				yylineno++;
" "	
%%
