#include <avr/io.h>
#include <avr/wdt.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include <stdio.h> 

class LED {
  typeof(DDRB)  *ddr;
  typeof(PORTB) *port;
  int            bit;

  public:

  LED() {}
  
  void init(typeof(ddr) d, typeof(port) p, int b) {
    ddr=d;
    port=p;
    bit=b;

    //*ddr &= ~(1<<bit);
    *ddr  |= 1<<bit;
    *port |= 1<<bit;
  }

  void set() {
    *port |= 1<<bit;
  };
  
  void clr() {
    *port &= ~(1<<bit);
  };


};


class MCU_PROTO {
  public:
//  BUTTON b1;
//  BUTTON b2;
  LED l1;
//  RELAY r1;
//  RELAY r2;

  MCU_PROTO() {
    l1.init(&DDRC, &PORTC, 0);
  
  }
  void sleep_s(int i) { _delay_ms(1000*i); }
};


int main(void) {
  wdt_disable();

  MCU_PROTO ic;

  cli();

  //printf("HELLO SPROTO\n");

  while (1) {
    ic.sleep_s(1);
    ic.l1.set();
    ic.sleep_s(1);
    ic.l1.clr();
  }

  return 0;
}
