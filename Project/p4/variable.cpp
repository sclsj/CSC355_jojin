#include "variable.h"
#include "symbol.h"
#include "expression.h"
#include "gpl_type.h"
#include "gpl_assert.h"
#include "error.h"
#include <sstream>
using namespace std;

Variable::Variable(Symbol *symbol)
{
    m_type = symbol->get_type();
    m_symbol = symbol;
    m_expression = nullptr;
}

Variable::Variable(Symbol *symbol, Expression *expression)
{
    m_type = symbol->get_type();
    m_symbol = symbol;
    m_expression = expression;
}

string Variable::get_name() const
{
  string name = m_symbol->get_name();
  // Add [] at the end of name string to indicate the variable is an array.
  if (m_expression)
  {
    name += "[]";
  }
  return name;
}

int Variable::get_int_value() const
{
    assert (m_symbol);
    if (is_array()) {
        return m_symbol->get_int_value(eval_index_with_error_checking());
    }
    return m_symbol->get_int_value();
}

double Variable::get_double_value() const
{
    assert (m_symbol);
    if (is_array()) {
        return m_symbol->get_double_value(eval_index_with_error_checking());
    }
    return m_symbol->get_double_value();
}

string Variable::get_string_value() const
{
    assert (m_symbol);
    if (is_array()) {
        return m_symbol->get_string_value(eval_index_with_error_checking());
    }
    return m_symbol->get_string_value();
}

void Variable::set(int value)
{
    assert(m_symbol);
    if (is_array()) {
        m_symbol->set(value, eval_index_with_error_checking());
    }
    else {
        m_symbol->set(value);
    }
}

void Variable::set(double value)
{
    assert(m_symbol);
    if (is_array()) {
        m_symbol->set(value, eval_index_with_error_checking());
    }
    else {
        m_symbol->set(value);
    }
}

void Variable::set(string value)
{
    assert(m_symbol);
    if (is_array()) {
        m_symbol->set(value, eval_index_with_error_checking());
    }
    else {
        m_symbol->set(value);
    }
}

/**
 * @brief Evaluate the array index expression and ensure it is within bounds.
 *
 * Evaluates the associated index expression to obtain an integer index for the
 * array element. If the computed index lies outside the valid range of the
 * symbol’s array, an error is reported and 0 is returned instead.
 * The value 0 is always guaranteed to be within bounds.
 *
 * @return The evaluated array index, or 0 if the index is out of bounds.
 *
 * @pre This function must only be called when the variable represents an array.
 *       (i.e., @c m_expression != nullptr)
 */
int Variable::eval_index_with_error_checking() const
{
  assert(m_expression); // should only be called if this is an array

  int index = m_expression->eval_int();

  // an annoying special case
  // if the index is -1 it confuses symbol that uses -1 for 
  //   not an array
  if (m_symbol->index_within_range(index))
  {
    return index;
  }
  else
  {
    Error::error(Error::ARRAY_INDEX_OUT_OF_BOUNDS,
                 m_symbol->get_name(),to_string(index));

    return 0; // 0 is always within range
  }
}
