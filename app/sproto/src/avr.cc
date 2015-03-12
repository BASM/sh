#include "avr.h"

MCU_PROTO::MCU_PROTO () {
  wdt_disable();
  cli();
  l1.init(&DDRC, &PORTC, 0);
  r1.init(&DDRB, &PORTB, 4);
  r2.init(&DDRC, &PORTC, 0);
  b1.init(&DDRD, &PORTD, &PIND, 3);
  b2.init(&DDRD, &PORTD, &PIND, 4);
}
