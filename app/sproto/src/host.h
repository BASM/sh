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

class LED {
  char pname[0x20];
  int  val;

  public:

  LED() {}

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
  LED l1;
//  RELAY r1;
//  RELAY r2;
  void sleep_s(int i) {usleep(i); }
};
