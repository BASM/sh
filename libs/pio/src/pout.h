#ifndef __POUT_H__
#define __POUT_H__

#include "shclass.h"

class aPOUT {
  public:
  aPOUT () {};
  virtual void init(void);
  virtual void set(fint val);
  virtual void set(void);
  virtual void clr(void);
};

#endif // __POUT_H__
