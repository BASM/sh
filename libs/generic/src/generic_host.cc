#include <unistd.h>

//extern FILE *icstdout;
FILE* icstdout=NULL;

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

