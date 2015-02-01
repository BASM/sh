#include <stdio.h>
#include <swclases.h>

int shmain(void) {
  MCU_sw ic;
  volatile int result;

  result = ic.BUTTONS.But1.check();
  return result;
}

int main(void) {
  return shmain();
}
