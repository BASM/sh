#ifndef __PIN_HOST_H__
#define __PIN_HOST_H__


class PIN {
  char pname[0x20];

  public:

  PIN() {}
  
  void init(const char *name) { }

  bool isOn() {
    return true;//XXX FIXME
  }

};

#endif // __PIN_HOST_H__
