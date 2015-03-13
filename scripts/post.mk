#MAKE=remake -x ${NOPRINTDIR}
MAKE=make ${NOPRINTDIR}

ALLDST+=$(DST:%.exe=%.hex)
ALLDST+=$(DST:%=host_%)
#ALLDST+=$(foreach i,$(DST),$i host_$i)


TBIN=$(@:host_%=%)
THOST=$(if $(@:host_%=),0,1)

TBOARD=$(${TBIN}-BOARD)
TBOARDNAME=$(firstword $(subst _, ,${TBOARD}))
TICNAME=$(lastword $(subst _, ,${TBOARD}))

.PHONY: rebuild
.SECONDARY: $(DST)

all: $(ALLDST)

rebuild:
	true

ifeq ($(REALRUN),)
#$(ALLDST):
%.hex: %.exe
	avr-objcopy -j .text -j .data -O ihex sproto.exe sproto.hex
	avr-size $<

%.exe: rebuild
	@mkdir -p gensrc
	if [ "${THOST}" = "0" ] ; then \
		$(BGEN) -b $(TBOARDNAME).yml -i ${TICNAME} ; \
		else \
		$(BGEN) -b $(TBOARDNAME).yml --host -i ${TICNAME} ; \
		fi
	REALRUN="1" \
	BINREAL="$@" \
	HOST="${THOST}" \
	BIN="${TBIN}" \
	BOARD="${TBOARD}" \
	BOARDNAME="${TBOARDNAME}" \
	ICNAME="${TICNAME}" ${MAKE} $@
else
include $(SCRIPTDIR)/postreal.mk
endif


clean:
	rm -Rf lib obj gensrc $(ALLDST) $(DST)
