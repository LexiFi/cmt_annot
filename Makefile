# This file is released under the terms of an MIT-like license.
# See the attached LICENSE file.
# Copyright 2016 by LexiFi.

include $(shell ocamlc -where)/Makefile.config

OCAMLFLAGS = -w +A-4-45 -warn-error -safe-string

ifeq ($(ARCH), none)
	OCAMLC = ocamlc $(OCAMLFLAGS)
	A_EXT = .cma
else
	OCAMLC = ocamlopt $(OCAMLFLAGS)
	A_EXT = .cmxa
endif

.PHONY: all clean

cmt_annot.install:
	echo "bin: [ \"cmt_annot$(EXE)\" ]" > cmt_annot.install

cmt_annot$(EXE): cmt_annot.ml
	$(OCAMLC) -I +compiler-libs -o cmt_annot$(EXE) ocamlcommon$(A_EXT) cmt_annot.ml

all: cmt_annot$(EXE) cmt_annot.install

clean:
	rm -f *.cm* cmt_annot$(EXE) *.o cmt_annot.install
