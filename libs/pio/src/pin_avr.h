#ifndef __PIN_AVR_H__
#define __PIN_AVR_H__

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

#endif // __POUT_AVR_H__
