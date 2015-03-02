#ifndef __SHCLASS_H__
#define __SHCLASS_H__

#include "shtype.h"
//#include <avr/iom328p.h>

// Fast int (for AVR sizeof(int) == 2, but fint is 1 byte)
//
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
