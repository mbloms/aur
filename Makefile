SHELL := /bin/bash
makepkg = "makepkg -s --config $(shell pwd)/Makepkg.conf"
pwd=$(shell pwd)

$(shell realpath --relative-to . x86_64/mbloms-aur.db): $(shell for pkg in *.mk; do cat $$pkg | grep 'pkg=' | sed s/^pkg=// ; done)
	repo-add -s -k 7F64B7A3F7F6819E $(shell realpath --relative-to . x86_64/mbloms-aur.db) $?

%.mk: %/PKGBUILD Makefile
	git config submodule.$*.ignore dirty
	echo "pkg=$(shell realpath --relative-to $(@D) $(shell cd $* && makepkg --config ../Makepkg.conf --packagelist))" > $@
	echo "\$$(pkg): $*/PKGBUILD" >> $@
	echo -e "\tcd $* && ${makepkg}" >> $@
	echo "$*: \$$(pkg)" >> $@

include $(shell for pkg in */PKGBUILD; do echo $${pkg%/PKGBUILD}.mk; done)

srcinfo: */.SRCINFO

%/.SRCINFO: %/PKGBUILD
	cd $(@D) && makepkg --printsrcinfo > .SRCINFO

%/PKGBUILD: FORCE
	cd $* && makepkg --config ../Makepkg.conf -od

FORCE:
