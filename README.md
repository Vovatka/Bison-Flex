# Транслятор flex-bison для *int-грамматики*

**Автор: Ткаченко Владимир КМБО-05-23**

## Грамматика G
```ebnf
<Program> ::= <StatementList>

<StatementList> ::= <Statement> | <StatementList> <Statement>

<Statement> ::= <Declaration> | <Assignment>

<Declaration> ::= int ID = <Expression> ;

<Assignment> ::= ID = <Expression> ;

<Expression> ::= <Term> | <Expression> + <Term> | <Expression> - <Term>

<Term> ::= <Factor> | <Term> * <Factor> | <Term> / <Factor>

<Factor> ::= IntLiteral | ID | ( <Expression> ) | - <Factor>
```

## Сборка через CMake

```bash
mkdir build && cd build && cmake .. && make && cd ..
```

## Запуск

```bash
./build/main examples/valid/precedence.intlang
```

## Автотестирование примеров

```bash
bash ./examples/run_tests.sh ./build/main
```

## Пример вывода:

```bash
Запуск тестов для intlang

Положительные примеры (valid/):
  PASS  valid/complex_precedence.intlang
       Output:
         Success
         Final variables state:
           a = 2
           b = 3
           c = 4
           res1 = 14
           res2 = 20
           d = 10
           e = 3
           res3 = 3
  PASS  valid/identifiers_underscore.intlang
       Output:
         Success
         Final variables state:
           _temp = 5
           var1 = 10
           my_var_2 = 20
           result = 35
  PASS  valid/nested_parens.intlang
       Output:
         Success
         Final variables state:
           x = 1
           y = 3
           z = 15
  PASS  valid/precedence.intlang
       Output:
         Success
         Final variables state:
           a = 5
           b = 3
           result = 17
           value = 25
  PASS  valid/reassignment.intlang
       Output:
         Success
         Final variables state:
           counter = 10
           final = 8
  PASS  valid/simple_decl_assign.intlang
       Output:
         Success
         Final variables state:
           x = 10
           y = 20
           z = 30
  PASS  valid/unary_minus.intlang
       Output:
         Success
         Final variables state:
           x = 10
           y = -10
           z = 10
           w = -15

Негативные примеры с выводом ошибок (invalid/):
  PASS  invalid/division_by_zero.intlang
       Detals:
         Ошибка: semantic error: Деление на ноль
  PASS  invalid/empty_parens.intlang
       Detals:
         Ошибка: syntax error, unexpected ')', expecting ID or INT_LITERAL or '-' or '('
  PASS  invalid/missing_operand.intlang
       Detals:
         Ошибка: syntax error, unexpected ';', expecting ID or INT_LITERAL or '-' or '('
  PASS  invalid/missing_semicolon.intlang
       Detals:
         Ошибка: syntax error, unexpected ID, expecting ';' or '+' or '-'
  PASS  invalid/statement_without_semicolon.intlang
       Detals:
         Ошибка: syntax error, unexpected INT_KW, expecting ';' or '+' or '-'
  PASS  invalid/syntax_error_expr.intlang
       Detals:
         Ошибка: syntax error, unexpected '+', expecting ID or INT_LITERAL or '-' or '('
  PASS  invalid/unknown_type.intlang
       Detals:
         Ошибка: syntax error, unexpected ID, expecting '='

Итог: 14 прошло / 0 упало / 14 всего
```
