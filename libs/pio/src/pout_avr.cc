#include "pout.h"

void
POUT_MASTER::set(fint val) {
  if (val) this->set();
  else     this->clr();
}