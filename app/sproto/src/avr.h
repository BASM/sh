#include <avr/io.h>
#include <avr/wdt.h>
#include <avr/interrupt.h>
#include <util/delay.h>

class BUTTON {
  typeof(DDRB)  *ddr;
  typeof(PORTB) *port;
  typeof(PINB)  *pin;
  int            bit;

  public:

  BUTTON() {}
  
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

class POUT {
  typeof(DDRB)  *ddr;
  typeof(PORTB) *port;
  int            bit;

  public:

  POUT() {}
  
  void init(typeof(ddr) d, typeof(port) p, int b) {
    ddr=d;
    port=p;
    bit=b;

    //*ddr &= ~(1<<bit);
    *ddr  |= 1<<bit;
    *port |= 1<<bit;
  }

  void set();
  void clr();

};


class MCU_PROTO {
  public:
  BUTTON b1;
//  BUTTON b2;
  POUT l1;
  POUT r1;
  POUT r2;
  MCU_PROTO();
  void sleep_s(int i) {_delay_ms(1000*i); }
  void sleep_ms(int i) {_delay_ms(i);}
};
