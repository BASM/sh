
#ifdef __AVR_ARCH__
#define icprintf(...)  printf(__VA_ARGS__)
#else
#include <stdio.h>
extern FILE* icstdout;
//#define icprintf(...) if (icstdout!=NULL) fprintf(icstdout, __VA_ARGS__)
#define icprintf(...) fprintf(icstdout, __VA_ARGS__)
#endif


class IO {
  public:
    virtual void putch(char ch)=0;
    virtual fint getch(bool block)=0;
};

class STDIO {
  public:
    int setio(IO *io);
};
