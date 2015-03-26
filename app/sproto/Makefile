include ../../scripts/build.mk

DST=sproto.exe

sproto.exe-BOARD=at328_sw
sproto.exe-OBJS=main.o

PRE=clean
POSTRUN=run

include ${POST}

run:
	./host_sproto.exe

p:
	prog  sproto.hex

