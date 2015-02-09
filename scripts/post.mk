#WFLAGS+= -Wall -Werror -Wmissing-declarations
WFLAGS+= -Wall -Werror #-Wmissing-prototypes
#CFLAGS+= $(WFLAGS) -Igensrc -I$(LIBDIR)/shlib/include
CFLAGS+= -Os $(WFLAGS) -Igensrc
CFLAGS+= ${BOARD}
CFLAGS+= -I${SCRIPTDIR}/templates

B_BOARDS=${BOARDS:%=%.yml}
B_LIBS=${BOARDS:%=blib/lib%.a}

NOPRINTDIR=--no-print-directory
MAKE=make ${NOPRINTDIR}

CXX=avr-g++
AR=avr-ar

ALLTRG+=${PRE}
ifeq ($(BOARDNAME),)
ALLTRG+=boardsgen
else
ifeq ($(ICNAME),)
ALLTRG+=icesgen
else
GENOK=1
ALLTRG+=libraris
endif
endif

all: $(DST)
	#${ALLTRG}

ifeq ($(BOARDNAME),)
boardsgen:
	for i in ${BOARDS} ; do BOARDNAME="$$i" $(MAKE} ; done
else
boardsgen:
	BOARDNAME=$(BOARDNAME) ${MAKE} icesgen
endif

ifeq ($(ICNAME),)
icesgen:  dirs
	for i in $(shell $(BGEN) boards/$(BOARDNAME).yml) ; do BOARDNAME="${BOARDNAME}" ICNAME="$$i" ${MAKE} ; done
else
icesgen:
	echo "*********************** BUILD ICC FOR ${BOARDNAME} and ${ICNAME}"
	#for i in $(shell $(BGEN) $(BOARDNAME).yml ices) ; do ICNAME="$$i" make ; done
endif

libraris: lib/lib${BOARDNAME}_${ICNAME}.a 
	echo "LIBARARYS for ${BOARDNAME} and ${ICNAME}"


L_OBJS+=obj/shclass.o
B_OBJS=${OBJS:%=obj/%}

BOARD=-mmcu=atmega328

generator_%:
	${BGEN} $*.yml 2> res || ( cat res && false )
	for i in $(shell $(BGEN) $*.yml) ; do GEN=1 B_OBJ="$$i" ${MAKE}  ; done
	false


BLIBOBJ=obj/${ICNAME}clases.o

ifeq ($(GENOK),1)
lib/lib%.a: ${BLIBOBJ}
	mkdir -p lib
	$(AR) rvs $@ ${BLIBOBJ}

generator:
	@mkdir -p gensrc
	$(BGEN) $(BOARDNAME).yml $(ICNAME)
else
lib/lib%.a:
	@$(subst _, ICNAME=,$(addprefix BOARDNAME=,$*)) ${MAKE} generator
	@$(subst _, ICNAME=,$(addprefix BOARDNAME=,$*)) ${MAKE} $@
endif

BINOBJS=$(addprefix obj/,${$(BIN)-OBJS})
BINBLIB=$(addprefix lib/lib,${$(BIN)-BOARD}.a)

ifeq ($(BIN),)
%.exe:
	if [ "$(BIN)" = "" ] ; then BIN=$@ ${MAKE} $@ ; fi
else
${BIN}: ${BINBLIB} ${BINOBJS}
	${CXX} -o $@  ${BINOBJS} ${BINBLIB}
	avr-size $@
endif

check:
	@if [ "${DST}" = "" ] ; then echo "You must set DST variable in the Makefile"; false ; fi
	@if [ "${OBJS}" = "" ] ; then echo "You must set OBJS variable in the Makefile"; false ; fi

obj/%.o: src/%.cc
	@mkdir -p obj
	${CXX} -c $(CFLAGS) -o $@ $<

obj/%.o: gensrc/%.cc
	@mkdir -p obj
	echo BUILD $@
	${CXX} -c $(CFLAGS) -o $@ $<

obj/%.o: ${SCRIPTDIR}/templates/%.cc
	@mkdir -p obj
	${CXX} -c $(CFLAGS) -o $@ $<


%.bin: $(OBJS)
	${CXX} -o $@ $(OBJS)

run:
	./$(DST)

clean:
	rm -Rf lib obj gensrc $(DST)
