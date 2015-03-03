#include "avr.h"

void POUT::set() { *port |= 1<<bit; };
void POUT::clr() { *port &= ~(1<<bit); };

MCU_PROTO::MCU_PROTO () {
  wdt_disable();
  cli();
  l1.init(&DDRC, &PORTC, 0);
  r1.init(&DDRC, &PORTC, 0);
  r2.init(&DDRC, &PORTC, 0);
  b1.init(&DDRD, &PORTD, &PIND, 3);
}
