#include "host.h"

void LED::set() { printf("Port: %s is 1\n", pname);}
void LED::clr() { printf("Port: %s is 0\n", pname);}

MCU_PROTO::MCU_PROTO () {
  l1.init("PORT C0",0);
  b1.init("PORT D4");
}
