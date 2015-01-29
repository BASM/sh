#WFLAGS+= -Wall -Werror -Wmissing-declarations
WFLAGS+= -Wall -Werror #-Wmissing-prototypes
CFLAGS+= $(WFLAGS) -Isrcgen -I$(LIBDIR)/shlib/include
CFLAGS+= ${BOARD}
CFLAGS+= -I${SCRIPTDIR}/templates

B_BOARDS=${BOARDS:%=boards/%.yml}
B_LIBS=${BOARDS:%=blib/lib%.a}

CXX=avr-g++
AR=avr-g++

#all: dirs brdgen ${DST}
all: dirs ${DST}

dirs:
	mkdir -p srcgen obj blib

brdgen: 
	echo ${BGEN}
	echo ${B_LIBS}
	@echo ${B_BOARDS}
	@for i in ${BOARDS} ; do make blib/lib$$i.a ; done

OBJS+=shclass.o

B_OBJS=${OBJS:%=obj/%}

BOARD=-mmcu=atmega328
blib/lib%.a:
	${BGEN} boards/$*.yml 2> res
	${AR} ra $(BOARD) -o obj/shclass.o ${INCDIR}/shclass.cc
	#${CXX} -c $(BOARD) -I${INCDIR} -o $*.o $(shell cat res) shclass.o
	#${CXX} -c $(BOARD) -I${INCDIR} -o $*.o $(shell cat res) shclass.o

%.exe: ${B_OBJS}
	${CXX} -o $@ ${BOARD} ${B_OBJS}

#obj/main.o
#all: check $(DST) run
#	echo "BUILD"

check:
	@if [ "${DST}" = "" ] ; then echo "You must set DST variable in the Makefile"; false ; fi
	@if [ "${OBJS}" = "" ] ; then echo "You must set OBJS variable in the Makefile"; false ; fi

obj/%.o: src/%.cc
	${CXX} -c $(CFLAGS) -o $@ $<
	echo BUILD $@

obj/%.o: srcgen/%.cc
	${CXX} -c $(CFLAGS) -o $@ $<
	echo BUILD $@

obj/%.o: ${SCRIPTDIR}/templates/%.cc
	${CXX} -c $(CFLAGS) -o $@ $<


%.bin: $(OBJS)
	${CXX} -o $@ $(OBJS)

run:
	./$(DST)

