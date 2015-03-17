#include <sh.h>
#include <stdio.h> 

int main(void) {
  MCU_sw ic;

  //printf("HELLO SPROTO\n");

  ic.led.set();

  while (1) {
    if (ic.buttons.b1.isOn() != ic.buttons.b2.isOn()) {
      ic.led.clr();
      ic.relay.r1.set();
    } else {
      ic.led.set();
      ic.relay.r1.clr();
    }
    ic.sleep_ms(100);
  }

  return 0;
}
