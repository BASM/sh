#MAKE=remake -x ${NOPRINTDIR}
MAKE=make ${NOPRINTDIR}


ALLDST+=$(foreach i,$(DST),$i host_$i)


TBIN=$(@:host_%=%)
THOST=$(if $(@:host_%=),0,1)

TBOARD=$(${TBIN}-BOARD)
TBOARDNAME=$(firstword $(subst _, ,${TBOARD}))
TICNAME=$(lastword $(subst _, ,${TBOARD}))

all: $(ALLDST)

ifeq ($(REALRUN),)
$(ALLDST):
	@mkdir -p gensrc
	if [ "${THOST}" = "0" ] ; then \
		$(BGEN) $(TBOARDNAME).yml ${TICNAME} ; \
		else \
		$(BGEN) $(TBOARDNAME).yml --host ${TICNAME} ; \
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
	rm -Rf lib obj gensrc $(DST)
