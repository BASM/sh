#include <stdio.h>
#include <string>
#define icprintf(...) fprintf(icstdout, __VA_ARGS__)

extern FILE *icstdout;
class Gui {
  int sock;
  public:
    Gui() {}
    int con();
    int usefile(std::string fname);
		int action(std::string object, std::string event);
};
extern Gui *gui;
