#include "shclass.h"

void
POUT_MASTER::set(fint val) {
  if (val) this->set();
  else     this->cli();
}
