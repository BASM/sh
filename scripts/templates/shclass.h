#ifndef __SHCLASS_H__
#define __SHCLASS_H__

#include "shtype.h"
//#include <avr/iom328p.h>

// Fast int (for AVR sizeof(int) == 2, but fint is 1 byte)
//
class POUT_MASTER {
  public:
  POUT_MASTER(void) {};
  void set(fint val) ;
  virtual void set()=0;
  virtual void cli()=0;
};


#endif
