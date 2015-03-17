#include <unistd.h>
void
MCU_sw::sleep_ms(int i) {
  usleep(i*1000);
}
