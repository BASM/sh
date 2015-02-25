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
  virtual void set();
  virtual void clr();
};

class shio {
  public:

};

//Standard STDIO wrapper
class STDIO {
  public:
    void setio(shio *io) {};

};

class MCU {
  public:
    void sleep_s(int i);
};


#endif
