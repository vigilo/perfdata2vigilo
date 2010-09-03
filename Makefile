NAME = perfdata2vigilo
LIBDIR = $(PREFIX)/lib
NAGIOSDIR = $(LIBDIR)/nagios/plugins
CONFDIR = $(SYSCONFDIR)/vigilo/perfdata2vigilo

INFILES = perfdata2vigilo general.conf

all: $(INFILES)

perfdata2vigilo: perfdata2vigilo.pl.in
	sed -e 's,@CONFDIR@,$(CONFDIR),g' $^ > $@
general.conf: general.conf.in
	sed -e 's,@SYSCONFDIR@,$(SYSCONFDIR),g;s,@LOCALSTATEDIR@,$(LOCALSTATEDIR),g' $^ > $@

install: $(INFILES)
	mkdir -p $(DESTDIR)$(NAGIOSDIR)/ $(DESTDIR)$(CONFDIR)/
	install -m 755 perfdata2vigilo $(DESTDIR)$(NAGIOSDIR)/
	install -m 644 general.conf $(DESTDIR)$(CONFDIR)/

clean:
	find $(CURDIR) -name "*~" -exec rm {} \;
	rm -f $(INFILES)

.PHONY: all install clean
