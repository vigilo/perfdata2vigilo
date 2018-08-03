%define module  perfdata2vigilo

Name:       vigilo-%{module}
Summary:    Nagios plugin to send perfdata to Vigilo
Version:    @VERSION@
Release:    @RELEASE@%{?dist}
Source0:    %{name}-%{version}.tar.gz
URL:        https://www.vigilo-nms.com
Group:      Applications/System
BuildRoot:  %{_tmppath}/%{name}-%{version}-%{release}-build
License:    GPLv2
Requires:   nagios
#Buildarch:  noarch  # On installe dans _libdir


%description
This Nagios perfdata plugin sends metrology data to Vigilo through a Nagios
connector.
This application is part of the Vigilo Project <https://www.vigilo-nms.com>

%prep
%setup -q

%build
make \
    LIBDIR=%{_libdir} \
    SYSCONFDIR=%{_sysconfdir} \
    LOCALSTATEDIR=%{_localstatedir}

%install
rm -rf $RPM_BUILD_ROOT
make install \
    DESTDIR=$RPM_BUILD_ROOT \
    LIBDIR=%{_libdir} \
    SYSCONFDIR=%{_sysconfdir} \
    LOCALSTATEDIR=%{_localstatedir}


%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(644,root,root,755)
%doc COPYING.txt README.txt
%attr(755,root,root) %{_libdir}/nagios/plugins/%{module}
%dir %{_sysconfdir}/vigilo/
%config(noreplace) %{_sysconfdir}/vigilo/%{module}
%{_sysconfdir}/nagios/plugins.d
%config(noreplace) %{_sysconfdir}/nagios/plugins.d/%{name}.cfg


%changelog
* Thu Jul 30 2009 Aurelien Bompard <aurelien.bompard@c-s.fr>
- rename

* Mon Feb 23 2009  Thomas Burguiere <thomas.burguiere@c-s.fr>
- first creation of the RPM from debian archive
