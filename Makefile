all: fabricversions

fabricversions:
	swift build -c release -Xswiftc -static-stdlib
	gzip -kf man/fabricversions.1

clean:
	rm -rf .build/ man/fabricversions.1.gz

install: all
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	install -m 755 .build/release/fabricversions $(DESTDIR)$(PREFIX)/bin/fabricversions
	install -m 644 man/fabricversions.1.gz $(DESTDIR)$(PREFIX)/share/man/man1/fabricversions.1.gz

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/fabricversions \
		$(DESTDIR)$(PREFIX)/share/man/man1/fabricversions.1.gz

.PHONY: all clean install uninstall
