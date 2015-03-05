#include <sh.h>
#include <stdio.h> 


int main(void) {
  MCU_PROTO ic;

  //printf("HELLO SPROTO\n");

  ic.l1.set();

  while (1) {
    if (ic.b1.isOn() != ic.b2.isOn()) {
      ic.l1.clr();
      ic.r1.set();
    } else {
      ic.l1.set();
      ic.r1.clr();
    }
    ic.sleep_ms(100);
  }

  return 0;
}
