makepkg = "makepkg --config $(shell pwd)/Makepkg.conf"
pwd=$(shell pwd)

x86_64/mbloms-aur.db.tar.xz: $(shell for pkg in */PKGBUILD; do echo $${pkg%/PKGBUILD}; done)

%.mk: %/PKGBUILD Makefile
	echo "pkg=$(shell realpath --relative-to $(@D) $(shell cd $* && makepkg --config ../Makepkg.conf --packagelist))" > $@
	echo "\$$(pkg): $*/PKGBUILD" >> $@
	echo -e "\tcd $* && ${makepkg}" >> $@
	echo "$*: \$$(pkg)" >> $@
	git config submodule.$*.ignore dirty

include $(shell for pkg in */PKGBUILD; do echo $${pkg%/PKGBUILD}.mk; done)

srcinfo: */.SRCINFO

%/.SRCINFO: %/PKGBUILD
	cd $(@D) && makepkg --printsrcinfo > .SRCINFO
