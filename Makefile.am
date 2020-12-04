my_confdir = $(sysconfdir)/vigilo/perfdata2vigilo/
EXTRA_DIST = *.txt *.in
CLEANFILES = $(nagiosplugins_SCRIPTS) $(nagiospluginsconf_DATA) $(my_conf_DATA)

nagiosplugins_SCRIPTS = perfdata2vigilo
nagiospluginsconf_DATA = vigilo-perfdata2vigilo.cfg
my_conf_DATA = general.conf

perfdata2vigilo: perfdata2vigilo.pl.in Makefile
	$(SED) -e 's,@CONFDIR[@],$(my_confdir),g' $< > $@
	$(TOUCH) --reference=$< $@

general.conf: general.conf.in Makefile
	$(SED) -e 's,@SYSCONFDIR[@],$(sysconfdir),g;s,@LOCALSTATEDIR[@],$(localstatedir),g' $< > $@
	$(TOUCH) --reference=$< $@

vigilo-perfdata2vigilo.cfg: vigilo-perfdata2vigilo.cfg.in Makefile
	$(SED) -e 's,@SYSCONFDIR[@],$(sysconfdir),g;s,@PLUGINDIR[@],$(nagiospluginsdir),g' $< > $@
	$(TOUCH) --reference=$< $@
