OPT=-Os

WFLAGS+= -Wall -Werror #-Wmissing-prototypes
#CFLAGS+= $(WFLAGS) -Igensrc -I$(LIBDIR)/shlib/include
CFLAGS+= $(OPT) $(WFLAGS) -Igensrc -Isrc
CFLAGS+= ${GCCBOARDNAME}
CFLAGS+= -I${SCRIPTDIR}/templates


ifeq ($(HOST),1)
GENOPT=--host
DEPOPT=_host
CXX=g++
AR=ar
OBJS=${${BIN}-OBJS:%.o=%_host.o}
else
INCLUDES+= -include avr/io.h
OBJS=${${BIN}-OBJS:%.o=%_avr.o}
ifeq (${BOARDNAME},at328)
GCCBOARDNAME=-mmcu=atmega328
ARCH=avr
endif
CXX=avr-g++
AR=avr-ar
endif # $(HOST),1

INCLUDES+= -include $(ICNAME)clases${OBJPREF}.h
OBJS:=${OBJS:%=obj/%}

ifeq ($(HOST),1)
OBJPREF=${DEPOPT}
else
OBJPREF=_${ARCH}
endif


BLIBOBJ=obj/${ICNAME}clases$(OBJPREF).o
BLIBOBJ+=obj/shclass${OBJPREF}.o


$(BINREAL):  ${OBJS} lib/lib$(BOARD)$(DEPOPT).a
	${CXX} ${OPT} -o $@ $^

lib/lib$(BOARD)$(DEPOPT).a: $(BLIBOBJ)
	mkdir -p lib
	$(AR) rvs $@ ${BLIBOBJ}

obj/%${OBJPREF}.o: gensrc/%${OBJPREF}.cc
	@mkdir -p obj
	echo BUILD $@
	${CXX} -c $(CFLAGS) -o $@ $<

obj/%${OBJPREF}.o: ${SCRIPTDIR}/templates/%${OBJPREF}.cc 
	@mkdir -p obj
	${CXX} ${INCLUDES} -c $(CFLAGS) -o $@ $<

obj/%${OBJPREF}.o: src/%.cc
	@mkdir -p obj
	${CXX} ${INCLUDES} -c $(CFLAGS) -o $@ $<