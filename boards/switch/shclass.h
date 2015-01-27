#include <inttypes.h>
#include <avr/io.h>
//#include <avr/iom328p.h>

// Fast int (for AVR sizeof(int) == 2, but fint is 1 byte)
typedef uint8_t fint;


/*
class POUT_LEDS {
  public:
  POUT_l1 l1;
};*/

class AvrBoard {
  public:
  PIN_BUTTONS BUTTONS;
  //POUT_LEDS   LEDS;
};

class Board_<%=@name%> {
  public:
    AvrBoard ic;
};
