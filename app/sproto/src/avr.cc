#include "avr.h"

void LED::set() { *port |= 1<<bit; };
void LED::clr() { *port &= ~(1<<bit); };

MCU_PROTO::MCU_PROTO () {
  wdt_disable();
  cli();
  l1.init(&DDRC, &PORTC, 0);
  b1.init(&DDRD, &PORTD, &PIND, 4);
}
