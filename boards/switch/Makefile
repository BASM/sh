include ../../scripts/build.mk

BOARDS=at328 arm


DST=test.exe
OBJS=main.o
#CXX=avr-g++
#CFLAGS=-Os

#BOARD=-mmcu=atmega328p


include ${POST}
rb:
	ruby main.rb
	$(CXX) -o test.exe $(CFLAGS) $(BOARD) shclass.cc main.cc #shclass.cc

gccs:
	$(CXX) -o test.exe $(CFLAGS) $(BOARD) main.cc #shclass.cc
	avr-objdump -D test.exe > dump

gcc:
	$(CXX) -c ${CFLAGS} ${BOARD} shclass.cc
	$(CXX) -c ${CFLAGS} ${BOARD} main.cc
	$(CXX) -o test.exe main.o shclass.o
	avr-objdump -D test.exe > dump

py:
	rm -Rf switch
	python3 main.py
