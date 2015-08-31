#include <stdlib.h>
#include <string>
#include <unistd.h>
#include <sys/types.h>          /* See NOTES */
#include <sys/socket.h>
#include <netdb.h>

//FIXME
//#include <swclases_host.h>

#include <stdio.h>
//extern FILE* icstdout;
//extern Gui *gui;
//#define icprintf(...) if (icstdout!=NULL) fprintf(icstdout, __VA_ARGS__)

//extern FILE *icstdout;
FILE* icstdout=NULL;
Gui guiobj;
Gui *gui=&guiobj;

///////////////////////////
ssize_t mendal_read(void *cookie, char *buf, size_t size) {
  printf("Mendal read %i\n", (int) size);

  return 0;
}

ssize_t mendal_write(void *cookie, const char *buf, size_t size) {
  size_t   i;
  IO      *io=(IO*)cookie;
  if (io==NULL) return 0;
  printf("Mendal write %i\n", (int) size);

  for (i=0;i<size;i++) io->putch(*buf++);

  return size;
}
//seek=NULL;
int mendal_close(void *cookie) {
  printf("Mendal close \n");


  return 0;
}
///////////////////////////

void
MCU_sw::sleep_ms(int i) {
  usleep(i*1000);
}

int STDIO::setio(IO *io) {
  cookie_io_functions_t mendal;
  mendal.read =mendal_read;
  mendal.write=mendal_write;
  mendal.seek =NULL;
  mendal.close=mendal_close;

  icstdout=fopencookie((void*)io,"r+",mendal);
  if (icstdout==NULL) {
    printf("Can't redefine stdio!!!\n");
    return 1;
  }
  setvbuf(icstdout, NULL, _IONBF, 0);
  return 0;
}

//TODO move it to the MCU class
    
int Gui::con() {
	int res;
	int range=10;
	int i;
	struct addrinfo hints;
	struct addrinfo *result, *rp;

	sock=-1;

	memset(&hints, 0, sizeof(struct addrinfo));
	hints.ai_family = AF_UNSPEC;
	hints.ai_socktype = SOCK_STREAM;
	hints.ai_flags = 0;
	hints.ai_protocol = 0;     

	for (i=3000; i<(3000+range); i++) {
		char servname[5]="3000";
		snprintf(servname,5,"%i",i);
		printf("Try %s port\n", servname);
		res = getaddrinfo("localhost", servname, &hints, &result);
		if (res != 0) {
			perror("Getaddrinfo error");
		}

		for (rp = result; rp != NULL; rp= rp->ai_next) {
			sock = socket(rp->ai_family, rp->ai_socktype, rp->ai_protocol);
			if (sock == -1) continue;
			if (connect(sock, rp->ai_addr, rp->ai_addrlen) != -1)
				break;
			close(sock);
			sock=-1;
		}
		freeaddrinfo(result);
		if (sock!=-1) break;
	}
	return sock;
};

int Gui::usefile(std::string fname) {
      int               res;
      std::string str;

      str = "ymlfile " + fname + "\n";

      res = write(sock, str.c_str(), str.size());
      if (res != (int) str.size() ) {
        printf("Error to send command\n");
      }
      str = "test1\ntest2\ntest3\n";
      res = write(sock, str.c_str(), str.size());
      if (res != (int) str.size() ) {
        printf("Error to send command\n");
      }
      return 0;
}

void
MCU_sw::connect() {
  int sock;
  printf("Connecting....\n");

  sock = gui->con();
  if (sock == -1) {
    printf("Error to connect: sock is: %i", sock);
    perror("");
    exit(1);
  }
  printf("Sock is: %i\n", sock);

  gui->usefile(YMLNAME);
  //sleep(3);
}



