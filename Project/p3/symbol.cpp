#include "symbol.h"
#include "gpl_assert.h"

using namespace std;

constexpr int DEFAULT_INT_VALUE = 42;
constexpr double DEFAULT_DOUBLE_VALUE = 3.14159;
const std::string DEFAULT_STRING_VALUE = "Hello World";

Symbol::Symbol(std::string name, int initial_value){
    m_name = name;
    m_type = INT;
    m_size = UNDEFINED_SIZE;
    m_data_void_ptr = new int(initial_value);
    validate();
}

Symbol::Symbol(std::string name, double initial_value){
    m_name = name;
    m_type = DOUBLE;
    m_size = UNDEFINED_SIZE;
    m_data_void_ptr = new double(initial_value);
    validate();
}
Symbol::Symbol(std::string name, std::string initial_value){
    m_name = name;
    m_type = STRING;
    m_size = UNDEFINED_SIZE;
    m_data_void_ptr = new string(initial_value);
    validate();
}

Symbol::Symbol(std::string name, Gpl_type type, int size) {
    m_name = name;
    m_type = type;
    m_size = size;
    switch(type){
        case INT_ARRAY:{
            auto *temp = new int[size];
            fill(temp, temp + size, DEFAULT_INT_VALUE);
            m_data_void_ptr = temp;
            break;
        }

        case DOUBLE_ARRAY: {
            auto *temp = new double[size];
            fill(temp, temp + size, DEFAULT_DOUBLE_VALUE);
            m_data_void_ptr = temp;
            break;
        }

        case STRING_ARRAY: {
            auto *temp = new string[size];
            fill(temp, temp + size, DEFAULT_STRING_VALUE);
            m_data_void_ptr = temp;
            break;
        }

        default:
            cerr << "Array type not implemented..." << endl;
    }
    validate();
}

Symbol::~Symbol()
{
  // The Symbol "owns" the object it contains, it must delete it
  if (!is_array())
    switch (m_type)
    {
      case INT: delete (int *) m_data_void_ptr; break;
      case DOUBLE: delete (double *) m_data_void_ptr; break;
      case STRING: delete (string *) m_data_void_ptr; break;
      default: assert(0);
    }
  else
    switch (m_type)
    {
      case INT_ARRAY: delete [] (int *) m_data_void_ptr; break;
      case DOUBLE_ARRAY: delete [] (double *) m_data_void_ptr; break;
      case STRING_ARRAY: delete [] (string *) m_data_void_ptr; break;
      default: assert(0);
    }
}

// strip away the ARRAY bit from the type if there is one
Gpl_type Symbol::get_base_type() const 
{

  if (m_type & ARRAY)
      return (Gpl_type) (m_type - ARRAY);
  else
      return m_type;
}

void Symbol::validate_type_and_index(Gpl_type type, int index) const
{
  assert(m_type & type);

  assert((index == UNDEFINED_INDEX && m_size == UNDEFINED_SIZE) 
         || (index >= 0 && m_size >= 1 && index < m_size));
}

void Symbol::validate() const
{
  if (m_type & ARRAY)
    assert(m_size > 0);
  else
    assert(m_size == UNDEFINED_SIZE);

  assert(m_data_void_ptr != nullptr);
  assert(!m_name.empty());
  assert(m_size != 0);
}

