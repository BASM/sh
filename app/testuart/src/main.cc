#include <stdio.h>
#include <swclases.h>

int shmain(void)  {
  MCU_sw ic;

  ic.stdio(&ic.Uart);

  printf("Hello world\n");

  return 0;
}
