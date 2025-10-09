/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     T_ERROR = 258,
     T_INT = 259,
     T_DOUBLE = 260,
     T_STRING = 261,
     T_TRIANGLE = 262,
     T_PIXMAP = 263,
     T_CIRCLE = 264,
     T_RECTANGLE = 265,
     T_TEXTBOX = 266,
     T_FORWARD = 267,
     T_INITIALIZATION = 268,
     T_TERMINATION = 269,
     T_ON = 270,
     T_ANIMATION = 271,
     T_IF = 272,
     T_FOR = 273,
     T_ELSE = 274,
     T_EXIT = 275,
     T_PRINT = 276,
     T_TRUE = 277,
     T_FALSE = 278,
     T_SPACE = 279,
     T_LEFTARROW = 280,
     T_RIGHTARROW = 281,
     T_UPARROW = 282,
     T_DOWNARROW = 283,
     T_LEFTMOUSE_DOWN = 284,
     T_MIDDLEMOUSE_DOWN = 285,
     T_RIGHTMOUSE_DOWN = 286,
     T_LEFTMOUSE_UP = 287,
     T_MIDDLEMOUSE_UP = 288,
     T_RIGHTMOUSE_UP = 289,
     T_MOUSE_MOVE = 290,
     T_MOUSE_DRAG = 291,
     T_F1 = 292,
     T_AKEY = 293,
     T_SKEY = 294,
     T_DKEY = 295,
     T_FKEY = 296,
     T_HKEY = 297,
     T_JKEY = 298,
     T_KKEY = 299,
     T_LKEY = 300,
     T_WKEY = 301,
     T_ZKEY = 302,
     T_LPAREN = 303,
     T_RPAREN = 304,
     T_LBRACE = 305,
     T_RBRACE = 306,
     T_LBRACKET = 307,
     T_RBRACKET = 308,
     T_SEMIC = 309,
     T_COMMA = 310,
     T_PERIOD = 311,
     T_ASSIGN = 312,
     T_PLUS_ASSIGN = 313,
     T_MINUS_ASSIGN = 314,
     T_PLUS_PLUS = 315,
     T_MINUS_MINUS = 316,
     T_SIN = 317,
     T_COS = 318,
     T_TAN = 319,
     T_ASIN = 320,
     T_ACOS = 321,
     T_ATAN = 322,
     T_SQRT = 323,
     T_ABS = 324,
     T_FLOOR = 325,
     T_RANDOM = 326,
     T_TOUCHES = 327,
     T_NEAR = 328,
     T_STAR = 329,
     T_SLASH = 330,
     T_PLUS = 331,
     T_MINUS = 332,
     T_PERCENT = 333,
     T_LT = 334,
     T_GT = 335,
     T_LE = 336,
     T_GE = 337,
     T_EQ = 338,
     T_NEQ = 339,
     T_NOT = 340,
     T_ANDAND = 341,
     T_OROR = 342,
     T_INT_CONSTANT = 343,
     T_DOUBLE_CONSTANT = 344,
     T_STRING_CONSTANT = 345,
     T_ID = 346,
     IF_NO_ELSE = 347,
     T_OR = 348,
     T_AND = 349,
     T_NOT_EQUAL = 350,
     T_EQUAL = 351,
     T_GREATER_EQUAL = 352,
     T_LESS_EQUAL = 353,
     T_GREATER = 354,
     T_LESS = 355,
     T_MOD = 356,
     T_DIVIDE = 357,
     T_MULTIPLY = 358,
     UNARY_OP = 359
   };
#endif
/* Tokens.  */
#define T_ERROR 258
#define T_INT 259
#define T_DOUBLE 260
#define T_STRING 261
#define T_TRIANGLE 262
#define T_PIXMAP 263
#define T_CIRCLE 264
#define T_RECTANGLE 265
#define T_TEXTBOX 266
#define T_FORWARD 267
#define T_INITIALIZATION 268
#define T_TERMINATION 269
#define T_ON 270
#define T_ANIMATION 271
#define T_IF 272
#define T_FOR 273
#define T_ELSE 274
#define T_EXIT 275
#define T_PRINT 276
#define T_TRUE 277
#define T_FALSE 278
#define T_SPACE 279
#define T_LEFTARROW 280
#define T_RIGHTARROW 281
#define T_UPARROW 282
#define T_DOWNARROW 283
#define T_LEFTMOUSE_DOWN 284
#define T_MIDDLEMOUSE_DOWN 285
#define T_RIGHTMOUSE_DOWN 286
#define T_LEFTMOUSE_UP 287
#define T_MIDDLEMOUSE_UP 288
#define T_RIGHTMOUSE_UP 289
#define T_MOUSE_MOVE 290
#define T_MOUSE_DRAG 291
#define T_F1 292
#define T_AKEY 293
#define T_SKEY 294
#define T_DKEY 295
#define T_FKEY 296
#define T_HKEY 297
#define T_JKEY 298
#define T_KKEY 299
#define T_LKEY 300
#define T_WKEY 301
#define T_ZKEY 302
#define T_LPAREN 303
#define T_RPAREN 304
#define T_LBRACE 305
#define T_RBRACE 306
#define T_LBRACKET 307
#define T_RBRACKET 308
#define T_SEMIC 309
#define T_COMMA 310
#define T_PERIOD 311
#define T_ASSIGN 312
#define T_PLUS_ASSIGN 313
#define T_MINUS_ASSIGN 314
#define T_PLUS_PLUS 315
#define T_MINUS_MINUS 316
#define T_SIN 317
#define T_COS 318
#define T_TAN 319
#define T_ASIN 320
#define T_ACOS 321
#define T_ATAN 322
#define T_SQRT 323
#define T_ABS 324
#define T_FLOOR 325
#define T_RANDOM 326
#define T_TOUCHES 327
#define T_NEAR 328
#define T_STAR 329
#define T_SLASH 330
#define T_PLUS 331
#define T_MINUS 332
#define T_PERCENT 333
#define T_LT 334
#define T_GT 335
#define T_LE 336
#define T_GE 337
#define T_EQ 338
#define T_NEQ 339
#define T_NOT 340
#define T_ANDAND 341
#define T_OROR 342
#define T_INT_CONSTANT 343
#define T_DOUBLE_CONSTANT 344
#define T_STRING_CONSTANT 345
#define T_ID 346
#define IF_NO_ELSE 347
#define T_OR 348
#define T_AND 349
#define T_NOT_EQUAL 350
#define T_EQUAL 351
#define T_GREATER_EQUAL 352
#define T_LESS_EQUAL 353
#define T_GREATER 354
#define T_LESS 355
#define T_MOD 356
#define T_DIVIDE 357
#define T_MULTIPLY 358
#define UNARY_OP 359




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 23 "gpl.y"
{
  int              union_int;
  double			union_double;
  std::string      *union_string;
}
/* Line 1529 of yacc.c.  */
#line 263 "y.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

