NAME = perfdata2vigilo
LIBDIR = $(PREFIX)/lib
NAGIOSDIR = $(LIBDIR)/nagios/plugins
CONFDIR = $(SYSCONFDIR)/vigilo/perfdata2vigilo

INFILES = perfdata2vigilo general.conf

all: $(INFILES)

define find-distro
if [ -f /etc/debian_version ]; then \
	echo "debian" ;\
elif [ -f /etc/mandriva-release ]; then \
	echo "mandriva" ;\
elif [ -f /etc/redhat-release ]; then \
	echo "redhat" ;\
else \
	echo "unknown" ;\
fi
endef
DISTRO := $(shell $(find-distro))
DIST_TAG = $(DISTRO)

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

SVN_REV = $(shell LANGUAGE=C LC_ALL=C svn info 2>/dev/null | awk '/^Revision:/ { print $$2 }')
rpm: clean pkg/$(NAME).$(DISTRO).spec
	mkdir -p build/$(NAME)
	rsync -a --exclude .svn --delete ./ build/$(NAME)
	mkdir -p build/rpm/{$(NAME),BUILD,TMP}
	cd build; tar -cjf rpm/$(NAME)/$(NAME).tar.bz2 $(NAME)
	cp pkg/$(NAME).$(DISTRO).spec build/rpm/$(NAME)/vigilo-$(NAME).spec
	rpmbuild -ba --define "_topdir $(CURDIR)/build/rpm" \
				 --define "_sourcedir %{_topdir}/$(NAME)" \
				 --define "_specdir %{_topdir}/$(NAME)" \
				 --define "_rpmdir %{_topdir}/$(NAME)" \
				 --define "_srcrpmdir %{_topdir}/$(NAME)" \
				 --define "_tmppath %{_topdir}/TMP" \
				 --define "_builddir %{_topdir}/BUILD" \
				 --define "svn .svn$(SVN_REV)" \
				 --define "dist .$(DIST_TAG)" \
				 build/rpm/$(NAME)/vigilo-$(NAME).spec
	mkdir -p dist
	find build/rpm/$(NAME) -type f -name "*.rpm" | xargs cp -a -f -t dist/

.PHONY: all install clean rpm
