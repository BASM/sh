PIOCUR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

CFLAGS+=-I${PIOCUR}/src

BLIBOBJ+=obj/pout${OBJPREF}.o
BLIBOBJ+=obj/pin${OBJPREF}.o
#BLIBOBJ+= asdfasdfkjl

obj/%${OBJPREF}.o: $(PIOCUR)/src/%.cc
	${CXX} ${INCLUDES} -c ${CFLAGS} -o $@ $<
