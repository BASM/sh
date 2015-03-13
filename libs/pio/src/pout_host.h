#ifndef __POUT_HOST_H__
#define __POUT_HOST_H__
//#include "pout.h"
#include <stdio.h>
#include <string.h>

class POUT {
  char pname[0x20];
  int  val;

  public:

  POUT() {}

  void init(const char *name, int val) {
    strcpy(pname,name);
    this->val=val;
  }

  void set();
  void clr();
};

#endif // __POUT_AVR_H__
