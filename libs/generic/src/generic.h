
class IO {
  public:
    virtual void putch(char ch);
    //virtual fint getch(void);
};

class STDIO {
  public:
    int setio(IO *io);
};
