all: fabricversions

fabricversions: gzipman
ifeq ($(NOSTATIC),1)
	swift build -c release
else
	swift build -c release -Xswiftc -static-stdlib
endif

gzipman:
	gzip -kf man/fabricversions.1

clean:
	rm -rf .build/ man/fabricversions.1.gz

install: all
	install -Dm 755 .build/release/fabricversions $(DESTDIR)$(PREFIX)/bin/fabricversions
	install -Dm 644 man/fabricversions.1.gz $(DESTDIR)$(PREFIX)/share/man/man1/fabricversions.1.gz

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/fabricversions \
		$(DESTDIR)$(PREFIX)/share/man/man1/fabricversions.1.gz

.PHONY: all clean install uninstall
