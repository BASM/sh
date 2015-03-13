#include <sh.h>
#include <stdio.h> 

//FIXME move to system library
#ifdef __AVR_ARCH__                                                                                          
#include <util/delay.h>
#define sleep_ms(arg) _delay_ms(arg)
#else
#include <unistd.h>
#define sleep_ms(arg) usleep(arg*1000)
#endif


int main(void) {
  MCU_sw ic;

  //printf("HELLO SPROTO\n");

  ic.led.set();

  while (1) {
    if (ic.buttons.b1.isOn() != ic.buttons.b2.isOn()) {
      ic.led.clr();
      ic.relay.r1.set();
    } else {
      ic.led.set();
      ic.relay.r1.clr();
    }
    sleep_ms(100);
    //legacy.sleep_ms(100);
  }

  return 0;
}
  //void sleep_s(int i) {_delay_ms(1000*i); }
  //void sleep_ms(int i) {_delay_ms(i);}
