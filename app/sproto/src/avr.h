#include <avr/io.h>
#include <avr/wdt.h>
#include <avr/interrupt.h>
#include <util/delay.h>

class PIN {
  typeof(DDRB)  *ddr;
  typeof(PORTB) *port;
  typeof(PINB)  *pin;
  int            bit;

  public:

  PIN() {}
  
  void init(typeof(ddr) d, typeof(port) po, typeof(pin) pi, int b) {
    ddr=d;
    port=po;
    pin=pi;
    bit=b;

    *ddr &= ~(1<<bit);
    //*ddr  |= 1<<bit;
    *port |= 1<<bit;
  }

  bool isOn() {
    return (((*pin)>>bit)&1) ? false : true;
  }

};


class MCU_PROTO {
  public:
  PIN b1;
  PIN b2;
  POUT l1;
  POUT r1;
  POUT r2;
  MCU_PROTO();
  void sleep_s(int i) {_delay_ms(1000*i); }
  void sleep_ms(int i) {_delay_ms(i);}
};
