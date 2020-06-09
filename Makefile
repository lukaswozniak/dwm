# dwm - dynamic window manager
# See LICENSE file for copyright and license details.

include config.mk

SRC = drw.c dwm.c util.c
OBJ = ${SRC:.c=.o}

all: options dwm

options:
	@echo dwm build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk

config.h:
	cp config.def.h $@

dwm: ${OBJ}
	${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	rm -f dwm ${OBJ} dwm-${VERSION}.tar.gz
	git submodule update --init dwmblocks && cd dwmblocks && make clean

dist: clean
	mkdir -p dwm-${VERSION}
	cp -R LICENSE Makefile README config.def.h config.mk\
		dwm.1 drw.h util.h ${SRC} dwm.png transient.c dwm-${VERSION}
	tar -cf dwm-${VERSION}.tar dwm-${VERSION}
	gzip dwm-${VERSION}.tar
	rm -rf dwm-${VERSION}

install: all
	sudo mkdir -p ${DESTDIR}${PREFIX}/bin
	sudo cp -f dwm ${DESTDIR}${PREFIX}/bin
	sudo chmod 755 ${DESTDIR}${PREFIX}/bin/dwm
	sudo mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sudo bash -c 'sed "s/VERSION/${VERSION}/g" < dwm.1 > ${DESTDIR}${MANPREFIX}/man1/dwm.1'
	sudo chmod 644 ${DESTDIR}${MANPREFIX}/man1/dwm.1
	sudo mkdir -p "${DESTDIR}/usr/share/xsessions"
	sudo cp -f dwm.desktop "${DESTDIR}/usr/share/xsessions/dwm.desktop"
	git submodule update --init dwmblocks && cd dwmblocks && make install

uninstall:
	sudo rm -f ${DESTDIR}${PREFIX}/bin/dwm ${DESTDIR}${MANPREFIX}/man1/dwm.1
	git submodule update --init dwmblocks && cd dwmblocks && make uninstall

.PHONY: all options clean dist install uninstall
