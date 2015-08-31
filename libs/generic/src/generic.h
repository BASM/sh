#ifndef __SH_GENERIC_H__
#define __SH_GENERIC_H__

#ifdef __AVR_ARCH__
#include "generic_avr.h"
#else
#include "generic_host.h"
#endif


class IO {
  public:
    virtual void putch(char ch)=0;
    virtual fint getch(bool block)=0;
};

class STDIO {
  public:
    int setio(IO *io);
};

#endif // __SH_GENERIC_H__
