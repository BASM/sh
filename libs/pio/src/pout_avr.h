#ifndef __POUT_AVR_H__
#define __POUT_AVR_H__
#include "pout.h"

class POUT {
  typeof(DDRB)  *ddr;
  typeof(PORTB) *port;
  int            bit;

  public:
  POUT() {}

  void init(typeof(ddr) d, typeof(port) p, int b) {
    ddr=d;
    port=p;
    bit=b;

    //*ddr &= ~(1<<bit);
    *ddr  |= 1<<bit;
    *port |= 1<<bit;
  }

  void set();
  void clr();

};

#endif // __POUT_AVR_H__
