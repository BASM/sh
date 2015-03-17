GENERICCUR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

INCLUDES+=-I${GENERICCUR}/src

BLIBOBJ+=obj/generic${OBJPREF}.o

obj/%${OBJPREF}.o: ${GENERICCUR}/src/%.cc
	${CXX} ${INCLUDES} -c ${CFLAGS} -o $@ $<
