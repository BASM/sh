#include "pout.h"

class POUT_AVR : public POUT {
  typeof(DDRB)  *ddr;
  typeof(PORTB) *port;
  int            bit;
  
  POUT (typeof(ddr) d, typeof(port) p, int b) {
    ddr=d;
    port=p;
    bit=b;
    init();
  };

};
