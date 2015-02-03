#ifndef __SHCLASS_H__
#define __SHCLASS_H__

#include "shtype.h"
//#include <avr/iom328p.h>

// Fast int (for AVR sizeof(int) == 2, but fint is 1 byte)
//
class POUT_MASTER {
  //int ddr;
  public:
  //POUT_MASTER(int ddr) {this->ddr=ddr};
  POUT_MASTER() {};
  void set(fint val) ;
  __attribute__((always_inline)) virtual void set()=0;
  __attribute__((always_inline)) virtual void cli()=0;
};


#endif
