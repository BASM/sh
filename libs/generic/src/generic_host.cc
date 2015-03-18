#include <unistd.h>
void
MCU_sw::sleep_ms(int i) {
  usleep(i*1000);
}

int STDIO::setio(IO *io) {

  printf("SET IO\n");
  return 0;
}

