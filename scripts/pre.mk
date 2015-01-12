#MKFILE=$(abspath $(lastword $(MAKEFILE_LIST)))
#MKDIR:=$(notdir $(patsubst %/,%,$(dir $(MKFILE))))
MKDIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
POST=$(MKDIR)/post.mk

LIBDIR=$(MKDIR)/../libs/

#Global lib for all programs.
LIBDIR_SHLIB=$(LIBDIR)/shlib/include
