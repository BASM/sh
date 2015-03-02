#define __DELAY_BACKWARD_COMPATIBLE__
#include <avr/io.h>
#include <util/delay.h>
#include "shclass.h"

void 
MCU::sleep_s(int i) {
  _delay_ms(1000*i);
}
