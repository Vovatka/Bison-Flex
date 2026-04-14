cmake_minimum_required(VERSION 3.16)
project(intlang_bison LANGUAGES C CXX)

set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)

find_package(BISON REQUIRED)
find_package(FLEX REQUIRED)

bison_target(intlangParser
    src/intlang.y
    ${CMAKE_CURRENT_BINARY_DIR}/intlang.tab.c
    DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/intlang.tab.h)

flex_target(intlangScanner
    src/intlang.l
    ${CMAKE_CURRENT_BINARY_DIR}/intlang.yy.c
    COMPILE_FLAGS "${FLEX_FLAGS}")

add_flex_bison_dependency(intlangScanner intlangParser)

add_executable(main
    ${BISON_intlangParser_OUTPUTS}
    ${FLEX_intlangScanner_OUTPUTS})

target_include_directories(main PRIVATE ${CMAKE_CURRENT_BINARY_DIR})

if(FLEX_LIBRARIES)
    target_link_libraries(main PRIVATE ${FLEX_LIBRARIES})
endif()
