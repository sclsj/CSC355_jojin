//
// Created by Jin Joy on 2025/11/8.
//
#include "symbol.h"
int main(){
    Symbol sx("x", 1);
    sx.set(7);                   // scalar int
    assert(sx.get_int_value() == 7);

    Symbol sa("a", INT_ARRAY, 3);
    sa.set(10, 0);
    sa.set(20, 1);
    sa.set(30, 2);
    assert(sa.get_int_value(1) == 20);

    Symbol ss("s", std::string("hi"));
    ss.set(std::string("bye"));
    assert(ss.get_string_value() == "bye");

}