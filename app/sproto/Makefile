include ../../scripts/build.mk

DST=sproto.exe

sproto.exe-BOARD=at328_sw
sproto.exe-OBJS=main.o

PRE=clean



### FIXME

#TYPEPROG=stk500v2 -P avrdoper
#AVRDUDE = avrdude -c ${TYPEPROG} -p m328p



####
###########################


include ${POST}

p:
	avr-objcopy -j .text -j .data -O ihex sproto.exe sproto.hex
	prog  sproto.hex
	false

