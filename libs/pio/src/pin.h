#define F_CPU 12000000L

#include <inttypes.h>
#include "shclass.h"
#include "shtype.h"

class PIN {
  typeof(DDRB)  *ddr;
  typeof(PORTB) *port;
  int           bit;
  public:
  POUT (typeof(ddr) d, typeof(port) p) {
    ddr=d;
    port=p;
    *ddr &= ~(1<<bit);
  };
  __attribute__((always_inline)) inline void set()      {*port |= 1<<bit;}
  __attribute__((always_inline)) inline void clr()      {*port &= 1<<bit;}
};
