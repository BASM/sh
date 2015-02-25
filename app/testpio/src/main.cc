#include <stdio.h>
#include <swclases.h>

int shmain(void)  {
  MCU_sw ic;

  while (1) {
    ic.sleep_s(1);
    ic.LEDS.l1.set();
    ic.sleep_s(1);
    ic.LEDS.l1.clr();
  }


  printf("Hello world\n");
  return 0;
}
