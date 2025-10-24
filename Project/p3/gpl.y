%{

// there is a compatibility problem with my current cygwin environment
// this appears to fix the problem
#undef __GNUC_MINOR__

#include "error.h"
#include "gpl_assert.h"
#include <iostream>
#include <sstream>
#include <cmath> // for floor()
#include <stack>

// symbol table
#include "symbol_table.h"
#include "symbol.h"
using namespace std;

extern int yylex();
extern int yyerror(const char *);
extern int line_count;  // from gpl.l, used for statement blocks

int undeclared = 0;

%}

%union {
  int              union_int;
  double			union_double;
  std::string      *union_string;
  Gpl_type         union_gpl_type;
}


// %token <union_string> T_ERROR             "error"

%error-verbose

%token T_INT                 "int"
%token T_DOUBLE              "double"
%token T_STRING              "string"
%token T_TRIANGLE            "triangle"
%token T_PIXMAP              "pixmap"
%token T_CIRCLE              "circle"
%token T_RECTANGLE           "rectangle"
%token T_TEXTBOX             "textbox"

%token T_FORWARD             "forward"
%token T_INITIALIZATION      "initialization"
%token T_TERMINATION         "termination"
%token T_ON                  "on"
%token T_ANIMATION           "animation"
%token T_IF                  "if"
%token T_FOR                 "for"
%token T_ELSE                "else"
%token T_EXIT                "exit"
%token T_PRINT               "print"
%token T_TRUE                "true"
%token T_FALSE               "false"

%token T_SPACE               "space"
%token T_LEFTARROW           "leftarrow"
%token T_RIGHTARROW          "rightarrow"
%token T_UPARROW             "uparrow"
%token T_DOWNARROW           "downarrow"
%token T_LEFTMOUSE_DOWN      "leftmouse_down"
%token T_MIDDLEMOUSE_DOWN    "middlemouse_down"
%token T_RIGHTMOUSE_DOWN     "rightmouse_down"
%token T_LEFTMOUSE_UP        "leftmouse_up"
%token T_MIDDLEMOUSE_UP      "middlemouse_up"
%token T_RIGHTMOUSE_UP       "rightmouse_up"
%token T_MOUSE_MOVE          "mouse_move"
%token T_MOUSE_DRAG          "mouse_drag"
%token T_F1                  "f1"
%token T_AKEY                "akey"
%token T_SKEY                "skey"
%token T_DKEY                "dkey"
%token T_FKEY                "fkey"
%token T_HKEY                "hkey"
%token T_JKEY                "jkey"
%token T_KKEY                "kkey"
%token T_LKEY                "lkey"
%token T_WKEY                "wkey"
%token T_ZKEY                "zkey"

%token T_LPAREN              "("
%token T_RPAREN              ")"
%token T_LBRACE              "{"
%token T_RBRACE              "}"
%token T_LBRACKET            "["
%token T_RBRACKET            "]"
%token T_SEMIC               ";"
%token T_COMMA               ","
%token T_PERIOD              "."

%token T_ASSIGN              "="
%token T_PLUS_ASSIGN         "+="
%token T_MINUS_ASSIGN        "-="
%token T_PLUS_PLUS           "++"
%token T_MINUS_MINUS         "--"

%token T_SIN                 "sin"
%token T_COS                 "cos"
%token T_TAN                 "tan"
%token T_ASIN                "asin"
%token T_ACOS                "acos"
%token T_ATAN                "atan"
%token T_SQRT                "sqrt"
%token T_ABS                 "abs"
%token T_FLOOR               "floor"
%token T_RANDOM              "random"

%token T_TOUCHES             "touches"
%token T_NEAR                "near"

%token T_MULTIPLY                "*"
%token T_DIVIDE               "/"
%token T_PLUS                "+"
%token T_MINUS               "-"
%token T_MOD             "%"

%token T_LESS                  "<"
%token T_GREATER                  ">"
%token T_LESS_EQUAL                  "<="
%token T_GREATER_EQUAL                  ">="
%token T_EQUAL                  "=="
%token T_NOT_EQUAL                 "!="
%token T_NOT                 "!"
%token T_AND              "&&"
%token T_OR                "||"

%token <union_int> T_INT_CONSTANT        "int constant"
%token <union_double> T_DOUBLE_CONSTANT     "double constant"
%token <union_string> T_STRING_CONSTANT     "string constant"
%token <union_string>  T_ID			         "identifier"


// COMPLETE ME

%type  <union_gpl_type>    simple_type

%token T_ERROR               "error"

%nonassoc IF_NO_ELSE
%nonassoc T_ELSE

%left T_NEAR T_TOUCHES
%left T_OR
%left T_AND
%left T_EQUAL T_NOT_EQUAL
%left T_LESS T_GREATER T_LESS_EQUAL T_GREATER_EQUAL
%left T_PLUS T_MINUS
%left T_MULTIPLY T_DIVIDE T_MOD
%nonassoc UNARY_OPS

%%

// updated January 2018

//---------------------------------------------------------------------
program:
    declaration_list block_list
    ;

//---------------------------------------------------------------------
declaration_list:
    declaration_list declaration
    | empty
    ;

//---------------------------------------------------------------------
declaration:
    variable_declaration T_SEMIC
    | object_declaration T_SEMIC
    | forward_declaration T_SEMIC
    ;

//---------------------------------------------------------------------
variable_declaration:
    simple_type  T_ID  optional_initializer
    {
        string name = *$2;
        Symbol_table *table = Symbol_table::instance();
        if (table->lookup(name) != nullptr){
            Error::error(Error::PREVIOUSLY_DECLARED_VARIABLE, name);
        }
        else {
            switch($1) {
                case INT:
                    table->insert(new Symbol(name, DEFAULT_INT_VALUE));
                case DOUBLE:
                    table->insert(new Symbol(name, DEFAULT_DOUBLE_VALUE));
                case STRING:
                    table->insert(new Symbol(name, DEFAULT_STRING_VALUE));
            }
        }
    }
//    | simple_type  T_ID  T_LBRACKET expression T_RBRACKET
    | simple_type T_ID T_LBRACKET T_INT_CONSTANT T_RBRACKET
    {
        string name = *$2;
        Symbol_table *table = Symbol_table::instance();
        int size = $4;
        if (table->lookup(name) != nullptr){
            Error::error(Error::PREVIOUSLY_DECLARED_VARIABLE, name);
        }
        else {
            if (size <= 1){
                Error::error(Error::INVALID_ARRAY_SIZE, name, to_string(size));
            }
            else {
                switch($1) {
                    case INT:
                        table->insert(new Symbol(name, INT_ARRAY, $4));
                    case DOUBLE:
                        table->insert(new Symbol(name, DOUBLE_ARRAY, $4));
                    case STRING:
                        table->insert(new Symbol(name, STRING_ARRAY, $4));
                }
            }
        }
    }
    ;

//---------------------------------------------------------------------
simple_type:
    T_INT { $$ = INT; }
    | T_DOUBLE { $$ = DOUBLE; }
    | T_STRING { $$ = STRING; }
    ;

//---------------------------------------------------------------------
optional_initializer:
    T_ASSIGN expression
    | empty
    ;

//---------------------------------------------------------------------
object_declaration:
    object_type T_ID T_LPAREN parameter_list_or_empty T_RPAREN
    | object_type T_ID T_LBRACKET expression T_RBRACKET
    ;

//---------------------------------------------------------------------
object_type:
    T_TRIANGLE
    | T_PIXMAP
    | T_CIRCLE
    | T_RECTANGLE
    | T_TEXTBOX
    ;

//---------------------------------------------------------------------
parameter_list_or_empty :
    parameter_list
    | empty
    ;

//---------------------------------------------------------------------
parameter_list :
    parameter_list T_COMMA parameter
    | parameter
    ;

//---------------------------------------------------------------------
parameter:
    T_ID T_ASSIGN expression
    ;

//---------------------------------------------------------------------
forward_declaration:
	T_FORWARD T_ANIMATION T_ID T_LPAREN check_animation_parameter T_RPAREN
    ;

//---------------------------------------------------------------------
block_list:
    block_list block
    | empty
    ;

//---------------------------------------------------------------------
block:
    initialization_block
    | termination_block
    | animation_block
    | on_block
    ;

//---------------------------------------------------------------------
initialization_block:
    T_INITIALIZATION statement_block
    ;

//---------------------------------------------------------------------
termination_block:
    T_TERMINATION statement_block
    ;

//---------------------------------------------------------------------
animation_block:
    T_ANIMATION T_ID T_LPAREN check_animation_parameter T_RPAREN T_LBRACE statement_list T_RBRACE end_of_statement_block
    ;

//---------------------------------------------------------------------
animation_parameter:
    object_type T_ID
    ;

//---------------------------------------------------------------------
check_animation_parameter:
    object_type T_ID
    ;

//---------------------------------------------------------------------
on_block:
    T_ON keystroke statement_block
    ;

//---------------------------------------------------------------------
keystroke:
	T_LEFTARROW
	| T_RIGHTARROW
	| T_UPARROW
	| T_DOWNARROW
	| T_SPACE
	| T_F1
	| T_AKEY
	| T_SKEY
	| T_DKEY
	| T_FKEY
	| T_HKEY
	| T_JKEY
	| T_KKEY
	| T_LKEY
	| T_WKEY
	| T_ZKEY
    ;

//---------------------------------------------------------------------
if_block:
    statement_block_creator statement end_of_statement_block
    | statement_block
    ;

//---------------------------------------------------------------------
statement_block:
    T_LBRACE statement_block_creator statement_list T_RBRACE end_of_statement_block
    ;

//---------------------------------------------------------------------
statement_block_creator:
    // this goes to nothing so that you can put an action here in p7
    ;

//---------------------------------------------------------------------
end_of_statement_block:
    // this goes to nothing so that you can put an action here in p7
    ;

//---------------------------------------------------------------------
statement_list:
    statement_list statement
    | empty
    ;

//---------------------------------------------------------------------
statement:
    | assign_statement T_SEMIC
    | if_statement
    | for_statement
    | print_statement T_SEMIC
    | exit_statement T_SEMIC
    | statement_block
    ;

//---------------------------------------------------------------------
if_statement:
    T_IF T_LPAREN expression T_RPAREN if_block %prec IF_NO_ELSE
    | T_IF T_LPAREN expression T_RPAREN if_block T_ELSE if_block
    ;

//---------------------------------------------------------------------
for_statement:
    T_FOR T_LPAREN statement_block_creator assign_statement_or_empty end_of_statement_block T_SEMIC expression T_SEMIC statement_block_creator assign_statement_or_empty end_of_statement_block T_RPAREN statement_block
    ;

//---------------------------------------------------------------------
print_statement:
    T_PRINT T_LPAREN expression T_RPAREN
    ;

//---------------------------------------------------------------------
exit_statement:
    T_EXIT T_LPAREN expression T_RPAREN
    ;

//---------------------------------------------------------------------
assign_statement_or_empty:
    assign_statement
    | empty
    ;

//---------------------------------------------------------------------
assign_statement:
    variable T_ASSIGN expression
    | variable T_PLUS_ASSIGN expression
    | variable T_MINUS_ASSIGN expression
    | variable T_PLUS_PLUS
    | variable T_MINUS_MINUS
    ;

//---------------------------------------------------------------------
variable:
    T_ID
    | T_ID T_LBRACKET expression T_RBRACKET
    | T_ID T_PERIOD T_ID
    | T_ID T_LBRACKET expression T_RBRACKET T_PERIOD T_ID
    ;

//---------------------------------------------------------------------
expression:
    primary_expression
    | expression T_OR expression
    | expression T_AND expression
    | expression T_LESS_EQUAL expression
    | expression T_GREATER_EQUAL  expression
    | expression T_LESS expression
    | expression T_GREATER  expression
    | expression T_EQUAL expression
    | expression T_NOT_EQUAL expression
    | expression T_PLUS expression
    | expression T_MINUS expression
    | expression T_MULTIPLY expression
    | expression T_DIVIDE expression
    | expression T_MOD expression
    | T_MINUS  expression %prec UNARY_OPS
    | T_NOT  expression %prec UNARY_OPS
    | math_operator T_LPAREN expression T_RPAREN
    | expression T_NEAR expression
    | expression T_TOUCHES expression
    ;

//---------------------------------------------------------------------
primary_expression:
    T_LPAREN  expression T_RPAREN
    | variable
    | T_INT_CONSTANT
    | T_TRUE
    | T_FALSE
    | T_DOUBLE_CONSTANT
    | T_STRING_CONSTANT
    ;

//---------------------------------------------------------------------
math_operator:
    T_SIN
    | T_COS
    | T_TAN
    | T_ASIN
    | T_ACOS
    | T_ATAN
    | T_SQRT
    | T_ABS
    | T_FLOOR
    | T_RANDOM
    ;

//---------------------------------------------------------------------
empty:
    // empty goes to nothing so that you can use empty in productions
    // when you want a production to go to nothing
    ;

