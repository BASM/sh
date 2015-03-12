#include "pout.h"
#include "pout_avr.h"


void POUT::set() { *port |=   1<<bit;  };
void POUT::clr() { *port &= ~(1<<bit); };
