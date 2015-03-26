
class IO {
  public:
    virtual void putch(char ch)=0;
    virtual fint getch(bool block)=0;
};

class STDIO {
  public:
    int setio(IO *io);
};
