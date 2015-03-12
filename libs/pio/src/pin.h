#define F_CPU 12000000L

#include <inttypes.h>
#include "shclass.h"
#include "shtype.h"

#ifdef __AVR_ARCH__
#include "pin_avr.h"
#else
#include "pin_host.h"
#endif

