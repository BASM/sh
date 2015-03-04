#include <sh.h>
#include <stdio.h> 


int main(void) {
  MCU_PROTO ic;

  //printf("HELLO SPROTO\n");

  ic.l1.set();
  ic.sleep_s(1);
  ic.l1.clr();

  while (1) {
    if (ic.b1.isOn() != ic.b2.isOn()) {
      ic.l1.set();
    } else {
      ic.l1.clr();
    }
    ic.sleep_ms(100);
  }

  return 0;
}
