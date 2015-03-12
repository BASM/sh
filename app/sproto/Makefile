include ../../scripts/build.mk

DST=sproto.exe

sproto.exe-BOARD=at328_sw
sproto.exe-OBJS=main.o
#sproto.exe-OBJS-avr=avr.o
sproto.exe-OBJS-host=host.o

PRE=clean

include ${POST}

p:
	prog  sproto.hex

