#include <generic.h>
#include "pout.h"
//#include "pout_avr.h"


void POUT::set() { gui->action(pname, "1"); }
void POUT::clr() { gui->action(pname, "0"); }
