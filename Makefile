LIBDIR = /usr/lib
NAGIOSDIR = $(LIBDIR)/nagios/plugins
SYSCONFDIR = /etc
LOCALSTATEDIR = /var
CONFDIR = $(SYSCONFDIR)/vigilo/perfdata2vigilo
DESTDIR =

INFILES = perfdata2vigilo general.conf

build: $(INFILES)

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

.PHONY: build install clean
