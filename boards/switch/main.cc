#include <stdio.h>
#include "shclass"

int shmain(void) {
  int result;
  result = sh.switch.BUTTONS.But1.check();
  printf("But1 check result: %i\n", result);

  return 0;
}
