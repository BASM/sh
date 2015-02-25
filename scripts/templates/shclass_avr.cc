#define __DELAY_BACKWARD_COMPATIBLE__
#include <avr/io.h>
#include <util/delay.h>
#include "shclass.h"

void
POUT_MASTER::set(fint val) {
  if (val) this->set();
  else     this->clr();
}

void 
MCU::sleep_s(int i) {
  _delay_ms(1000*i);
}
