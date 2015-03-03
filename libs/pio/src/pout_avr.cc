#include "pout.h"
#include "pout_avr.h"

void
POUT_AVR::set(fint val) {
  if (val) this->set();
  else     this->clr();
}

void
POUT_AVR::init(void) {
  *ddr &= ~(1<<bit);
}

void
POUT_AVR::set(void) {
  *port |= 1<<bit;
}

void
POUT_AVR::clr(void) {
  *port &= ~(1<<bit);
}

