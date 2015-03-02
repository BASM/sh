#include <unistd.h>
#include "shclass.h"

void 
MCU::sleep_s(int i) {
  usleep(1000*i);
}
