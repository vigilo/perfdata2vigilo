NAGIOSDIR = /usr/lib/nagios/plugins

install: install_files install_users install_permissions

install_users:

install_files:
	mkdir -p $(DESTDIR)$(NAGIOSDIR)/ 
	install -p -m 755 perf2store $(DESTDIR)$(NAGIOSDIR)/

install_permissions:
	chown nagios:nagios $(DESTDIR)$(NAGIOSDIR)/perf2store

clean:
	find $(CURDIR) -name "*~" -exec rm {} \;

.PHONY: install install_users install_files install_permissions clean
