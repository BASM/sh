SCRIPTDIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
POST=$(SCRIPTDIR)/post.mk

BGEN=ruby -I${SCRIPTDIR} ${SCRIPTDIR}/bgen.rb

INCDIR=${SCRIPTDIR}/templates
