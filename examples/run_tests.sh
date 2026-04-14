#!/usr/bin/env bash

BINARY="${1:?Использование: $0 <путь_к_транслятору>}"

if [ ! -f "$BINARY" ]; then
    echo "Ошибка: Файл '$BINARY' не найден."
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VALID_DIR="$SCRIPT_DIR/valid"
INVALID_DIR="$SCRIPT_DIR/invalid"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

pass=0
fail=0
total=0

run_test() {
    local file="$1"
    local expect_success="$2"
    
    local label
    label="$(basename "$(dirname "$file")")/$(basename "$file")"

    total=$((total + 1))

    output=$("$BINARY" "$file" 2>&1)
    exit_code=$?

    if [ "$expect_success" -eq 1 ] && [ "$exit_code" -eq 0 ]; then
        echo -e "  ${GREEN}PASS${NC}  $label"
        pass=$((pass + 1))
    elif [ "$expect_success" -eq 0 ] && [ "$exit_code" -ne 0 ]; then
        echo -e "  ${GREEN}PASS${NC}  $label"
        pass=$((pass + 1))
        echo "       Detals: $(echo "$output" | head -1)"
    elif [ "$expect_success" -eq 1 ]; then
        echo -e "  ${RED}FAIL${NC}  $label  ${YELLOW}← ожидался успех (код $exit_code)${NC}"
        echo "       Output:"
        echo "$output" | head -2 | sed 's/^/         /'
        fail=$((fail + 1))
    else
        echo -e "  ${RED}FAIL${NC}  $label  ${YELLOW}← ожидалась ошибка, но код возврата 0${NC}"
        fail=$((fail + 1))
    fi
}

echo "Запуск тестов для intlang"
echo ""

echo "Положительные примеры (valid/):"
shopt -s nullglob
for f in "$VALID_DIR"/*.intlang; do
    run_test "$f" 1
done
shopt -u nullglob

echo ""

echo "Негативные примеры с выводом ошибок (invalid/):"
shopt -s nullglob
for f in "$INVALID_DIR"/*.intlang; do
    run_test "$f" 0
done
shopt -u nullglob

echo ""
echo -e "Итог: ${GREEN}$pass прошло${NC} / ${RED}$fail упало${NC} / $total всего"

if [ "$fail" -eq 0 ]; then
    exit 0
else
    exit 1
fi
