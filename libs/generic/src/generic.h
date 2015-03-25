
class IO {
  public:
    virtual void putch(char ch)=0;
    //virtual fint getch(void);
};

class STDIO {
  public:
    int setio(IO *io);
};
