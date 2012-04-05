NAME = perfdata2vigilo

INFILES = perfdata2vigilo general.conf

all: $(INFILES)

include buildenv/Makefile.common.nopython

perfdata2vigilo: perfdata2vigilo.pl.in
	sed -e 's,@CONFDIR@,$(CONFDIR),g' $^ > $@
general.conf: general.conf.in
	sed -e 's,@SYSCONFDIR@,$(SYSCONFDIR),g;s,@LOCALSTATEDIR@,$(LOCALSTATEDIR),g' $^ > $@

install: $(INFILES)
	mkdir -p $(DESTDIR)$(NPLUGDIR)/ $(DESTDIR)$(CONFDIR)/
	install -m 755 perfdata2vigilo $(DESTDIR)$(NPLUGDIR)/
	install -m 644 general.conf $(DESTDIR)$(CONFDIR)/

clean: clean_common
	rm -f $(INFILES)


.PHONY: all install clean rpm sdist
