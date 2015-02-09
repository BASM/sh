#include <stdio.h>
#include <string.h>
#include <swclases.h>
#include <util/delay.h>

#include <avr/interrupt.h>
                        
#define deb(...) printf(__VA_ARGS__);

#define RS485_START_SIGN 0x99
  
MCU_sw ic;
//////////////////////////////////
//
// LIBARARY

#define RS485_DDR  DDRC
#define RS485_PORT PORTC
#define RS485_PIN  PINC
#define RS485_BIT  (1<<2) 
class RS485 {
  public:
  RS485();
  void setin()  { RS485_PORT |=  RS485_BIT; }
  void setout() { RS485_PORT &= ~RS485_BIT; }

};

RS485::RS485() {
#ifndef F_CPU
#error Please set F_CPU!
#endif
  UCSR0A = 0;
  UCSR0B = 0x18;
  UCSR0B |= RXEN0;
  UCSR0C = 0x06;

//#define BAUD 9600
//#define BAUD 38400
#define BAUD 115200
#include <util/setbaud.h>
    UBRR0H = UBRRH_VALUE;
    UBRR0L = UBRRL_VALUE;
#if USE_2X
    UCSR0A |= (1 << U2X0);
#else
    UCSR0A &= ~(1 << U2X0);
#endif
    //RS485 Direction
    DDRC   &= ~(1<<2);
    this->setin();
}
//FIXME
#define ICADDR 0x11

#define MAX_PACK 0x20
uint8_t RS485_resv_buff[MAX_PACK];
uint8_t RS485_resv_size=0;
uint8_t COMMAND=0;

//RS485_Vec
ISR(USART_RX_vect, ISR_BLOCK) {

  uint8_t recv=10;//XXX FIXME = RS485.recv()

  if (RS485_resv_size<MAX_PACK) {
    RS485_resv_buff[RS485_resv_size++]=recv;
  }
}

//FIXME change CRC 
uint8_t RS485_CRC(uint8_t *data, int size) {
  int i;
  int res=0x55;
  for (i=0; i<size; i++) {
    res ^= *data++; 
  }
  return res;
}

void RS485_reset(void) {
  int i;
  int cop=0;

  //i==1 -- maybe CRC is wrong, drop first byte
  for (i=1; i<RS485_resv_size; i++) {
    if (RS485_resv_buff[i] == RS485_START_SIGN) {
      break;
    }
  }
  cop = RS485_resv_size-i;
  if (cop>0) memcpy(RS485_resv_buff, &RS485_resv_buff[i], cop);
  RS485_resv_size=cop;
}

static void RS485_parser(void) {
  uint8_t crc_header;
  uint8_t datasize;
  uint8_t cmd;

  //if (RS485_resv_size < 4) return;
  if (RS485_resv_size < (5+2)) return;

  if (RS485_resv_buff[0] != RS485_START_SIGN) {
    deb("ERROR: WRONG SIGN\n");
    RS485_reset();
    return;
  }

  if (RS485_resv_buff[1] != ICADDR) {
    deb("ERROR: DON'T MINE OVER ICADDR\n");
    RS485_reset();
    return;
  }
/*FIXME IGNORE
  if (RS485_resv_buff[2] != ICADDR) {
    RS485_reset();
    return;
  }*/

  if (RS485_resv_buff[3]) {
    uint8_t byte = RS485_resv_buff[3];
    if ( (byte>>7) == 1) {//FIXME read don't support 
      deb("ERROR: ONLY WRITE MODE SUPPORT\n");
      RS485_reset();
      return;
    }
  }

  crc_header = RS485_CRC(RS485_resv_buff, 4); 
  if (RS485_resv_buff[4] != crc_header) { //CRC error
    deb("HEADER CRC ERROR\n");
    RS485_reset();
    return;
  }

  datasize = RS485_resv_buff[4] & 0x7f;

  if (datasize != 1 ) { //XXX FIXME
    deb("DATA SIZE != 1\n");
    RS485_reset();
    return;
  }

  cmd = RS485_resv_buff[5];
  if (RS485_CRC(&cmd, 1) != RS485_resv_buff[6]) {
    deb("DATA CRC ERROR\n");
    //DATA CRC error
    RS485_reset();
    return ;
  }
  
  COMMAND=cmd;

  return ;
}


////////////////////////////////
#define sleep(a) _delay_ms(a * 1000)

void cmd_run(int cmd) {
  switch (cmd) {
    case 0xc1:  ic.LEDS.l1.set(); break;
    case 0xc2:  ic.LEDS.l1.clr(); break;

    case 0xc3:  ic.RELAY.R1.clr(); break;
    case 0xc4:  ic.RELAY.R1.set(); break;

    case 0xc5:  ic.RELAY.R2.clr(); break;
    case 0xc6:  ic.RELAY.R2.set(); break;

    case 0xc7:  ic.RELAY.R3.clr(); break;
    case 0xc8:  ic.RELAY.R3.set(); break;

    case 0xc9:  ic.RELAY.R4.clr(); break;
    case 0xca:  ic.RELAY.R4.set(); break;
  }
}

int shmain(void) {
  RS485  rs;

  sei();

  while (1) {
    ic.LEDS.l1.set();
    sleep(1);
    ic.LEDS.l1.clr();
    sleep(1);

    RS485_parser();

    if (COMMAND!=0) {
      cmd_run(COMMAND);
      COMMAND=0;
    }
  }

  return 0;
}


