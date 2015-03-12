#include <sh.h>
#include <stdio.h> 


int main(void) {
  MCU_sw ic;
  MCU_PROTO legacy;

  //printf("HELLO SPROTO\n");

  ic.leds.l1.set();

  while (1) {
    if (legacy.b1.isOn() != legacy.b2.isOn()) {
      ic.leds.l1.clr();
      ic.relay.r1.set();
    } else {
      ic.leds.l1.set();
      ic.relay.r1.clr();
    }
    legacy.sleep_ms(100);
  }

  return 0;
}
