%{
#include <stdio.h>
#include "y.tab.h"
%}

%%

"&&"	return AND;
"||"	return OR;
"<"	return LESS;
">"	return GREAT;
"<="	return LESSEQ;
">="	return GREATEQ;
"=="	return EQUAL;
"!="	return NOTEQUAL;
"+"	return PLUS;
"-"	return MINUS;
\*	return STAR;
"/"	return SLASH;
\n
\t

%%
