#include "pout.h"
//#include "pout_avr.h"


void POUT::set() { printf("Port: %s is 1\n", pname);}
void POUT::clr() { printf("Port: %s is 0\n", pname);}
