#ifndef __POUT_H__
#define __POUT_H__

#include "shclass.h"

#ifdef __AVR_ARCH__
#include "pout_avr.h"
#else
#include "pout_host.h"
#endif

#endif // __POUT_H__
