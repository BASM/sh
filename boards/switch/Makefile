include ../../scripts/build.mk

BOARDS=at328

DST=test.exe
OBJS=main.o


include ${POST}
clean:
	rm -Rf blib obj gensrc test.exe res









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
