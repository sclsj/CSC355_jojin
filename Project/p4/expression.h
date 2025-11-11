
#ifndef EXPRESSION_H
#define EXPRESSION_H

#include "gpl_type.h"

#include <vector>
#include <string>
#include <iostream>
using namespace std;

class Variable;
class Constant;


class Expression
{
  public:
    Expression(int value);
    Expression(double value);
    Expression(string *value);

    Expression(Variable *variable);
    Expression(Expression *lhs, Operator_type op, Expression *rhs);

    Expression(Operator_type op,
               Expression *operand
              );

    Gpl_type get_type() {return m_type;}
    
    // Evaluate expressions. Check the instructions for more detail.
    int eval_int();
    double eval_double();
    string eval_string();

    bool eval_variable() {return m_variable;}

    // copied from variable
    bool is_numeric() const {return m_type & INT || m_type & DOUBLE;}

  private:

    Gpl_type m_type = NO_TYPE;
    Operator_type m_op = NO_OP;
    Expression *m_rhs = nullptr;
    Expression *m_lhs = nullptr;
    Constant *m_constant = nullptr;
    Variable *m_variable = nullptr;
    void create_constant_expression();

};

#endif // #ifndef EXPRESSION_H
