CUR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

INCLUDES+=-I${CUR}/src

BLIBOBJ+=obj/pout${OBJPREF}.o
#BLIBOBJ+= asdfasdfkjl

obj/%${OBJPREF}.o: ${CUR}/src/%.cc
	${CXX} ${INCLUDES} -c ${CFLAGS} -o $@ $<
