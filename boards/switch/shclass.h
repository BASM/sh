
class PIN() {
  public:
    int check(void);
}

class PINS() {
  public:
  PIN But1;
}

class AvrBoard() {
  public:
  PINS BUTTONS;
}

class Board() {
  public:
    AvrBoard ic;


}
