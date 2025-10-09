%{

#include "error.h"
#include "parser.h" // replacement for y.tab.h

#include <ctype.h>
#include <iostream>
using namespace std;


int line_count = 1;          // used to keep track of the input line

extern Error error_handler;  // error reporting object

/* count line feeds */
void count_lines(char *str)
{
  while(*str)
  {
    if (*str++ == '\n')
    {
        line_count ++;
    }
  }
}

void discard()
{
  count_lines(yytext);
}

/* the following functions are "called" when a token is found */

int emit(int token)
{
  return(token);
}

int emit_with_line_number(int token)
{
  yylval.union_int = line_count;
  return emit(token);
}

int emit_error(int token)
{
  error_handler.error(Error::ILLEGAL_TOKEN,yytext);
  yylval.union_string = new string(yytext);
  return emit(token);
}

int j;



void get_int_value()
{
  // assumes that the string in yytext is an integer
  // convert the string yytext into an integer
  // put the int into global union used to send values to the parser (record.y)
  // the union and its union_int field are declared in record.y
  yylval.union_int = atoi(yytext);
}

void get_double_value()
{
  yylval.union_double = atof(yytext);
}

void get_string_value()
{
  // Would like to put a string in the union, but the way the union works
  // it has to be a pointer to a string.
  yylval.union_string = new string(yytext);
}
 
void error()
{
  // have the error handling object report the problem
  // note: it uses line_count as a global variable
  error_handler.error(Error::ILLEGAL_TOKEN, yytext);

  // create a string to hold the current text
  // put that string in the yylval union so it can be used by parser (.y file)
  yylval.union_string = new string(yytext);
}



%}

%%

\/\/.*                             discard();
[ \n\t\r]                          discard();

"int"                return emit(T_INT);
"double"             return emit(T_DOUBLE);
"string"             return emit(T_STRING);
"triangle"           return emit(T_TRIANGLE);
"pixmap"             return emit(T_PIXMAP);
"circle"             return emit(T_CIRCLE);
"rectangle"          return emit(T_RECTANGLE);
"textbox"            return emit(T_TEXTBOX);

"forward"            return emit(T_FORWARD);
"initialization"     return emit(T_INITIALIZATION);
"termination"        return emit(T_TERMINATION);
"on"                 return emit(T_ON);
"animation"          return emit(T_ANIMATION);
"if"                 return emit(T_IF);
"for"                return emit(T_FOR);
"else"               return emit(T_ELSE);
"exit"               return emit_with_line_number(T_EXIT);
"print"              return emit_with_line_number(T_PRINT);
"true"               return emit(T_TRUE);
"false"              return emit(T_FALSE);

"space"              return emit(T_SPACE);
"leftarrow"          return emit(T_LEFTARROW);
"rightarrow"         return emit(T_RIGHTARROW);
"uparrow"            return emit(T_UPARROW);
"downarrow"          return emit(T_DOWNARROW);
"leftmouse_down"     return emit(T_LEFTMOUSE_DOWN);
"middlemouse_down"   return emit(T_MIDDLEMOUSE_DOWN);
"rightmouse_down"    return emit(T_RIGHTMOUSE_DOWN);
"leftmouse_up"       return emit(T_LEFTMOUSE_UP);
"middlemouse_up"     return emit(T_MIDDLEMOUSE_UP);
"rightmouse_up"      return emit(T_RIGHTMOUSE_UP);
"mouse_move"         return emit(T_MOUSE_MOVE);
"mouse_drag"         return emit(T_MOUSE_DRAG);
"f1"                 return emit(T_F1);
"akey"               return emit(T_AKEY);
"skey"               return emit(T_SKEY);
"dkey"               return emit(T_DKEY);
"fkey"               return emit(T_FKEY);
"hkey"               return emit(T_HKEY);
"jkey"               return emit(T_JKEY);
"kkey"               return emit(T_KKEY);
"lkey"               return emit(T_LKEY);
"wkey"               return emit(T_WKEY);
"zkey"               return emit(T_ZKEY);

"("                  return emit(T_LPAREN);
")"                  return emit(T_RPAREN);
"{"                  return emit(T_LBRACE);
"}"                  return emit(T_RBRACE);
"["                  return emit(T_LBRACKET);
"]"                  return emit(T_RBRACKET);
";"                  return emit(T_SEMIC);
","                  return emit(T_COMMA);
"."                  return emit(T_PERIOD);

"="                  return emit(T_ASSIGN);
"+="                 return emit(T_PLUS_ASSIGN);
"-="                 return emit(T_MINUS_ASSIGN);
"++"                 return emit(T_PLUS_PLUS);
"--"                 return emit(T_MINUS_MINUS);

"sin"                return emit(T_SIN);
"cos"                return emit(T_COS);
"tan"                return emit(T_TAN);
"asin"               return emit(T_ASIN);
"acos"               return emit(T_ACOS);
"atan"               return emit(T_ATAN);
"sqrt"               return emit(T_SQRT);
"abs"                return emit(T_ABS);
"floor"              return emit(T_FLOOR);
"random"             return emit(T_RANDOM);

"touches"            return emit(T_TOUCHES);
"near"               return emit(T_NEAR);

"*"                  return emit(T_STAR);
"/"                  return emit(T_SLASH);
"+"                  return emit(T_PLUS);
"-"                  return emit(T_MINUS);
"%"                  return emit(T_PERCENT);

"<"                  return emit(T_LT);
">"                  return emit(T_GT);
"<="                 return emit(T_LE);
">="                 return emit(T_GE);
"=="                 return emit(T_EQ);
"!="                 return emit(T_NEQ);
"!"                  return emit(T_NOT);
"&&"                 return emit(T_ANDAND);
"||"                 return emit(T_OROR);

[0-9]+          			get_int_value(); return T_INT_CONSTANT;
[0-9]+\.[0-9]*|\.[0-9]+		get_double_value(); return T_DOUBLE_CONSTANT;
[A-Za-z_]+[A-Za-z0-9_]*     get_string_value(); return T_ID;
\"([^"]*)\"					yylval.union_string = new string(yytext, 1, yyleng - 2); return T_STRING_CONSTANT;

.               error(); return T_ERROR;
