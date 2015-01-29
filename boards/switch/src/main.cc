#include <stdio.h>
#include <icclases.h>
//#include <shclass.h>

int shmain(void) {

  MCU_ic ic;

  volatile int result;
  result = ic.BUTTONS.But1.check();

  return result;
}

int main(void) {
  return shmain();
}
