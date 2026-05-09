%define parse.error verbose

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
void yyerror(const char *s);

#define MAX_VARS 100
typedef struct {
    char name[50];
    int value;
    int declared;
} Variable;

Variable variables[MAX_VARS];
int var_count = 0;

int get_var_index(const char* name) {
    for (int i = 0; i < var_count; i++) {
        if (strcmp(variables[i].name, name) == 0) {
            return i;
        }
    }
    if (var_count < MAX_VARS) {
        strncpy(variables[var_count].name, name, 49);
        variables[var_count].value = 0;
        variables[var_count].declared = 0;
        return var_count++;
    }
    yyerror("Слишком много переменных");
    exit(1);
}

void set_var_value(const char* name, int val) {
    int idx = get_var_index(name);
    variables[idx].value = val;
}

int get_var_value(const char* name) {
    int idx = get_var_index(name);
    return variables[idx].value;
}
%}

%union {
    int ival;
    char* str;
}

%token INT_KW
%token <str> ID
%token <ival> INT_LITERAL

%type <ival> expression term factor statement_list statement declaration assignment

%%

program:
    statement_list
        {
            printf("Success\n");
            printf("Final variables state:\n");
            for (int i = 0; i < var_count; i++) {
                printf("  %s = %d\n", variables[i].name, variables[i].value);
            }
        }
;

statement_list:
    statement
  | statement_list statement
;

statement:
    declaration
  | assignment
;

declaration:
    INT_KW ID '=' expression ';'
        { 
            int idx = get_var_index($2);
            variables[idx].declared = 1;
            variables[idx].value = $4;
            free($2);
        }
;

assignment:
    ID '=' expression ';'
        {
            set_var_value($1, $3);
            free($1);
        }
;

expression:
    expression '+' term   { $$ = $1 + $3; }
  | expression '-' term   { $$ = $1 - $3; }
  | term                  { $$ = $1; }
;

term:
    term '*' factor       { $$ = $1 * $3; }
  | term '/' factor       
        { 
            if ($3 == 0) {
                yyerror("semantic error: Деление на ноль");
                YYERROR;
            } else {
                $$ = $1 / $3; 
            }
        }
  | factor                { $$ = $1; }
;

factor:
    INT_LITERAL           { $$ = $1; }
  | ID                    
        { 
            $$ = get_var_value($1); 
            free($1);
        }
  | '(' expression ')'    { $$ = $2; }
  | '-' factor            { $$ = -$2; }
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Ошибка: %s\n", s);
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Использование: %s <файл>\n", argv[0]);
        return 1;
    }

    FILE *f = fopen(argv[1], "r");
    if (!f) {
        perror(argv[1]);
        return 1;
    }

    extern FILE *yyin;
    yyin = f;

    int result = yyparse();
    fclose(f);

    return result;
}
