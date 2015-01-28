#include <stdio.h>
#include "icclases.h"

int shmain(void) {

  MCU_ic ic;

  volatile int result;
  result = ic.BUTTONS.But1.check();

  return 0;
}

int main(void) {
  return shmain();
}
