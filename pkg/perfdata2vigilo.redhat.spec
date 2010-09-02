%define module  perfdata2vigilo
%define name    vigilo-%{module}
%define version 2.0.0
%define release 1%{?svn}

Name:       %{name}
Summary:    Nagios plugin to send perfdata to Vigilo
Version:    %{version}
Release:    %{release}
Source0:    %{module}.tar.bz2
URL:        http://www.projet-vigilo.org
Group:      System/Servers
BuildRoot:  %{_tmppath}/%{name}-%{version}-%{release}-build
License:    GPLv2
Requires:   nagios
Buildarch:  noarch


%description
This Nagios perfdata plugin sends metrology data to Vigilo through a Nagios
connector.
This application is part of the Vigilo Project <http://vigilo-project.org>

%prep
%setup -q -n %{module}

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
%defattr(-,root,root)
%doc COPYING README README.fr
%{_libdir}/nagios/plugins/%{module}
%dir %{_sysconfdir}/vigilo/
%config %{_sysconfdir}/vigilo/%{module}


%changelog
* Thu Jul 30 2009 Aurelien Bompard <aurelien.bompard@c-s.fr>
- rename

* Mon Feb 23 2009  Thomas Burguiere <thomas.burguiere@c-s.fr>
- first creation of the RPM from debian archive
