NOZIPMAN=0
DESTDIR=/usr/local

all: fabricversions

fabricversions: gzipman
	swift build -c release

gzipman:
ifeq ($(NOZIPMAN),1)
	true
else
	gzip -kf man/fabricversions.1
endif

clean:
	rm -rf .build/ man/fabricversions.1.gz

install: installMan
	install -Dm 755 .build/release/fabricversions $(DESTDIR)/bin/fabricversions

installMan:
ifeq ($(NOZIPMAN),1)
	install -Dm 644 man/fabricversions.1 $(DESTDIR)/share/man/man1/fabricversions.1
else
	install -Dm 644 man/fabricversions.1.gz $(DESTDIR)/share/man/man1/fabricversions.1.gz
endif

uninstall: uninstallman
	rm -f $(DESTDIR)/bin/fabricversions

uninstallMan:
ifeq ($(NOZIPMAN),1)
	rm -f $(DESTDIR)/share/man/man1/fabricversions.1
else
	rm -f $(DESTDIR)/share/man/man1/fabricversions.1.gz
endif

.PHONY: all clean install uninstall
