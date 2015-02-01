#WFLAGS+= -Wall -Werror -Wmissing-declarations
WFLAGS+= -Wall -Werror #-Wmissing-prototypes
#CFLAGS+= $(WFLAGS) -Igensrc -I$(LIBDIR)/shlib/include
CFLAGS+= -Os $(WFLAGS) -Igensrc
CFLAGS+= ${BOARD}
CFLAGS+= -I${SCRIPTDIR}/templates

B_BOARDS=${BOARDS:%=boards/%.yml}
B_LIBS=${BOARDS:%=blib/lib%.a}

CXX=avr-g++
AR=avr-ar

all: dirs ${B_LIBS} ${DST}
	echo ${B_BOARDS}
	echo ${B_LIBS}

dirs:
	mkdir -p gensrc obj blib

brdgen: 
	echo ${BGEN}
	echo ${B_LIBS}
	@echo ${B_BOARDS}
	@for i in ${BOARDS} ; do make blib/lib$$i.a ; done

L_OBJS+=obj/shclass.o
B_OBJS=${OBJS:%=obj/%}

BOARD=-mmcu=atmega328

generator_%:
	${BGEN} boards/$*.yml 2> res

blib/lib%.a: generator_% ${L_OBJS}
	${AR} rvs $@ ${L_OBJS}
	

%.exe: ${B_OBJS}
	${CXX} -o $@ ${BOARD} ${B_OBJS}

check:
	@if [ "${DST}" = "" ] ; then echo "You must set DST variable in the Makefile"; false ; fi
	@if [ "${OBJS}" = "" ] ; then echo "You must set OBJS variable in the Makefile"; false ; fi

obj/%.o: src/%.cc
	${CXX} -c $(CFLAGS) -o $@ $<

obj/%.o: gensrc/%.cc
	echo BUILD $@
	${CXX} -c $(CFLAGS) -o $@ $<

obj/%.o: ${SCRIPTDIR}/templates/%.cc
	${CXX} -c $(CFLAGS) -o $@ $<


%.bin: $(OBJS)
	${CXX} -o $@ $(OBJS)

run:
	./$(DST)

