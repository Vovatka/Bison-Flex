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
  PASS  valid/identifiers_underscore.intlang
  PASS  valid/nested_parens.intlang
  PASS  valid/precedence.intlang
  PASS  valid/reassignment.intlang
  PASS  valid/simple_decl_assign.intlang
  PASS  valid/unary_minus.intlang

Негативные примеры с выводом ошибок (invalid/):
  PASS  invalid/empty_parens.intlang
       Detals: Ошибка синтаксиса: syntax error, unexpected ')', expecting ID or INT_LITERAL or '-' or '('
  PASS  invalid/missing_operand.intlang
       Detals: Ошибка синтаксиса: syntax error, unexpected ';', expecting ID or INT_LITERAL or '-' or '('
  PASS  invalid/missing_semicolon.intlang
       Detals: Ошибка синтаксиса: syntax error, unexpected ID, expecting ';' or '+' or '-'
  PASS  invalid/statement_without_semicolon.intlang
       Detals: Ошибка синтаксиса: syntax error, unexpected INT_KW, expecting ';' or '+' or '-'
  PASS  invalid/syntax_error_expr.intlang
       Detals: Ошибка синтаксиса: syntax error, unexpected '+', expecting ID or INT_LITERAL or '-' or '('
  PASS  invalid/unknown_type.intlang
       Detals: Ошибка синтаксиса: syntax error, unexpected ID, expecting '='

Итог: 13 прошло / 0 упало / 13 всего
```
