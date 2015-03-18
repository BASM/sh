UARTCUR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
INCLUDES+=-I${UARTCUR}/src
BLIBOBJ+=obj/uart${OBJPREF}.o

obj/%${OBJPREF}.o: ${UARTCUR}/src/%.cc
	${CXX} ${INCLUDES} -c ${CFLAGS} -o $@ $<
