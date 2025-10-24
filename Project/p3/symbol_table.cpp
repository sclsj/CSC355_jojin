#include "symbol_table.h"
#include "symbol.h"
#include "gpl_assert.h"
using namespace std;

#include <vector>
#include <algorithm> // for sort algorithm

/* static */ Symbol_table *Symbol_table::m_instance = nullptr;

/* static */ Symbol_table * Symbol_table::instance()
{
  if (!m_instance)
    m_instance = new Symbol_table();
  return m_instance;
}

Symbol_table::Symbol_table()= default;

Symbol_table::~Symbol_table()
{
  cerr << "~Symbol_table()... not implemented..." << endl;
}

bool Symbol_table::insert(Symbol *symbol) {
    return m_symbols.insert({symbol->get_name(), symbol}).second;
}

Symbol *Symbol_table::lookup(std::string name) const {
    auto index = m_symbols.find(name);
    if (index != m_symbols.end()){
        return index->second;
    }
    return nullptr;
}

void Symbol_table::print(ostream &os) const {
    vector<pair<string, Symbol*>> sorted(m_symbols.begin(), m_symbols.end());
    sort(sorted.begin(), sorted.end(), [](auto a, auto b){return a.first < b.first;});
    for (const auto& i : sorted) {
        i.second->print(os);
    }
}
