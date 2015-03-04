#include "host.h"

void POUT::set() { printf("Port: %s is 1\n", pname);}
void POUT::clr() { printf("Port: %s is 0\n", pname);}

MCU_PROTO::MCU_PROTO () {
  l1.init("PORT C0",0);
  r1.init("PORT C0 REL1",0);
  r2.init("PORT C0 REL2",0);
  b1.init("PORT D4");
}
