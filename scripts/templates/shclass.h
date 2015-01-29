#include <inttypes.h>
#include <avr/io.h>
//#include <avr/iom328p.h>

// Fast int (for AVR sizeof(int) == 2, but fint is 1 byte)
typedef uint8_t fint;

class POUT_MASTER {
  virtual void set();
  virtual void cli();
  void set(fint val);
};

