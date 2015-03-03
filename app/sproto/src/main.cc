#include <sh.h>
#include <stdio.h> 


int main(void) {
  MCU_PROTO ic;
  int r1cur=0;
  bool b1old=0;

  //printf("HELLO SPROTO\n");

  ic.l1.set();
  ic.sleep_s(1);
  ic.l1.clr();
  ic.sleep_s(1);
  ic.l1.set();
  ic.sleep_s(1);
  ic.l1.set();

  while (1) {
    bool sg = ic.b1.isOn();

    if (sg != b1old) {
      b1old=sg;
      r1cur = !r1cur;

      if (r1cur==true) ic.r1.set();
      else             ic.r1.clr();
    }
    ic.sleep_ms(100);
  }

  return 0;
}
