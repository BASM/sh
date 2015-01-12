#WFLAGS+= -Wall -Werror -Wmissing-declarations
WFLAGS+= -Wall -Werror -Wmissing-prototypes
CFLAGS+= $(WFLAGS) -I$(LIBDIR)/shlib/include

all: check $(DST) run
	echo "BUILD"

check:
	@if [ "${DST}" = "" ] ; then echo "You must set DST variable in the Makefile"; false ; fi
	@if [ "${OBJS}" = "" ] ; then echo "You must set OBJS variable in the Makefile"; false ; fi

%.o: src/%.c
	gcc -c $(CFLAGS) -o $@ $<
	echo BUILD $@

%.bin: $(OBJS)
	gcc -o $@ $(OBJS)

run:
	./$(DST)

