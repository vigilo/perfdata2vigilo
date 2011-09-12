NAME = perfdata2vigilo
PKGNAME = vigilo-$(NAME)
SYSCONFDIR = /etc
LOCALSTATEDIR = /var
LIBDIR = /usr/lib
NAGIOSDIR = /usr/lib$(if $(realpath /usr/lib64),64,)/nagios/plugins
CONFDIR = $(SYSCONFDIR)/vigilo/$(NAME)
DESTDIR =

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

VERSION := $(shell cat VERSION.txt)

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
	rm -rf build


GIT_CHSET = $(shell git log -1 --format=format:%h .)
GIT_CHSET_COUNT = $(shell git rev-list --no-merges $(GIT_CHSET) | wc -l | xargs expr 1 +)
RELEASE_TAG = $(if $(RELEASE),1,0.$(GIT_CHSET_COUNT).g$(GIT_CHSET))

sdist: dist/$(PKGNAME)-$(VERSION)$(if $(RELEASE),,.g$(GIT_CHSET)).tar.gz
dist/$(PKGNAME)-$(VERSION).tar.gz dist/$(PKGNAME)-$(VERSION)%.tar.gz:
	mkdir -p build/sdist/$(notdir $(patsubst %.tar.gz,%,$@))
	rsync -aL --exclude .svn --exclude /dist --exclude /build --delete ./ build/sdist/$(notdir $(patsubst %.tar.gz,%,$@))
	mkdir -p dist
	cd build/sdist; tar -czf $(CURDIR)/$@ $(notdir $(patsubst %.tar.gz,%,$@))
	@echo "Source tarball is: $@"

rpm: clean pkg/$(NAME).$(DISTRO).spec dist/$(PKGNAME)-$(VERSION).tar.gz
	mkdir -p build/rpm/{$(NAME),BUILD,TMP}
	mv dist/$(PKGNAME)-$(VERSION).tar.gz build/rpm/$(NAME)/
	sed -e 's/@VERSION@/'`cat VERSION.txt`'/;s/@RELEASE@/$(RELEASE_TAG)/' \
		pkg/$(NAME).$(DISTRO).spec > build/rpm/$(NAME)/$(PKGNAME).spec
	rpmbuild -ba --define "_topdir $(CURDIR)/build/rpm" \
				 --define "_sourcedir %{_topdir}/$(NAME)" \
				 --define "_specdir %{_topdir}/$(NAME)" \
				 --define "_rpmdir %{_topdir}/$(NAME)" \
				 --define "_srcrpmdir %{_topdir}/$(NAME)" \
				 --define "_tmppath %{_topdir}/TMP" \
				 --define "_builddir %{_topdir}/BUILD" \
				 --define "dist .$(DIST_TAG)" \
				 $(RPMBUILD_OPTS) \
				 build/rpm/$(NAME)/$(PKGNAME).spec
	mkdir -p dist
	find build/rpm/$(NAME) -type f -name "*.rpm" | xargs cp -a -f -t dist/


.PHONY: all install clean rpm sdist
