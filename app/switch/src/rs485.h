#ifndef __RS485_H__
#define __RS485_H__

#define RS485_DDR  DDRC
#define RS485_PORT PORTC
#define RS485_PIN  PINC
#define RS485_BIT  (1<<2) 


class RS485_rw {
  public:
  RS485_rw();
  void setin()  { RS485_PORT |=  RS485_BIT; }
  void setout() { RS485_PORT &= ~RS485_BIT; }
};

#endif //__RS485_H__
