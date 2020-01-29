makepkg = "makepkg --config $(shell pwd)/Makepkg.conf"
pwd=$(shell pwd)



%.mk: %/PKGBUILD Makefile
	echo "pkg=$(shell realpath --relative-to $(@D) $(shell cd $* && makepkg --config ../Makepkg.conf --packagelist))" > $@
	echo "\$$(pkg): $*/PKGBUILD" >> $@
	echo -e "\tcd $* && ${makepkg}" >> $@
	echo "$*: \$$(pkg)" >> $@

include $(shell for pkg in */PKGBUILD; do echo $${pkg%/PKGBUILD}.mk; done)

x86_64/mbloms-aur.db.tar.xz: $(shell for pkg in */PKGBUILD; do echo $${pkg%/PKGBUILD}; done)

srcinfo: */.SRCINFO

%/.SRCINFO: %/PKGBUILD
	cd $(@D) && makepkg --printsrcinfo > .SRCINFO

