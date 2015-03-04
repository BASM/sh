#include <stdio.h>
#include <unistd.h>
#include <string.h>

class BUTTON {
  char pname[0x20];
  public:

  BUTTON() {}

  void init(const char *name) {
    strcpy(pname, name);
  }

  bool isOn() {
    return true;
  }

};

class POUT {
  char pname[0x20];
  int  val;

  public:

  POUT() {}

  void init(const char *name, int val) {
    strcpy(pname,name);
    this->val=val;
  }

  void set();
  void clr();
};


class MCU_PROTO {
  public:
  MCU_PROTO();
  BUTTON b1;
//  BUTTON b2;
  POUT l1;
  POUT r1;
  POUT r2;
  void sleep_s(int i) {usleep(i*1000*1000); }
  void sleep_ms(int i) {usleep(i*1000); }
};
