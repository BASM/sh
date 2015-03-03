#include <stdio.h>
#include <swclases.h>

int shmain(void)  {
  printf("Hello world\n");

  MCU_sw ic;
//  auto *l1 = &ic.LEDS.l1;


  while (1) {
    ic.sleep_s(1);
    ic.LEDS.l1.set();
    ic.sleep_s(1);
    ic.LEDS.l1.clr();
  }

  printf("Hello world\n");
  return 0;
}

int main(void) {

  shmain();

  return 0;
}
