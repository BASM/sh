#include <stdio.h>
#include <swclases.h>

int shmain(void)  {
  MCU_sw ic;

  ic.stdio.setio(ic.Uart.stdio());


  printf("Hello world\n");
  return 0;
}
