%{
#include "intlang.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%option noyywrap nounput noinput

%%

"int"       { return INT_KW; }

[a-zA-Z_][a-zA-Z0-9_]* { 
    yylval.str = strdup(yytext); 
    return ID; 
}

[0-9]+      { yylval.ival = atoi(yytext); return INT_LITERAL; }

"+"         { return '+'; }
"-"         { return '-'; }
"*"         { return '*'; }
"/"         { return '/'; }
"="         { return '='; }
";"         { return ';'; }
"("         { return '('; }
")"         { return ')'; }

[ \t\r\n]+  { }
"//"[^\n]*  { } 

.           { 
              return yytext[0]; 
            }

%%
