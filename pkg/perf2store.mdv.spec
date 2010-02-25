%define module  perf2store
%define name    vigilo-%{module}
%define version 1.1
%define release 2

Name:       %{name}
Summary:    Nagios plugin to send perfdata to StoreMe
Version:    %{version}
Release:    %{release}
Source0:    %{module}.tar.bz2
URL:        http://www.projet-vigilo.org
Group:      System/Servers
BuildRoot:  %{_tmppath}/%{name}-%{version}-%{release}-build
License:    GPLv2
Requires:   nagios
Buildarch:  noarch

# Renamed from nagios-plugin-perf2store
Obsoletes:  nagios-plugin-perf2store < 1.1-2
Provides:   nagios-plugin-perf2store = %{version}-%{release}


%description
This Nagios perfdata plugin sends metrology data to StoreMe
This application is part of the Vigilo Project <http://vigilo-project.org>

%prep
%setup -q -n %{module}

%build

%install
rm -rf $RPM_BUILD_ROOT
make DESTDIR=$RPM_BUILD_ROOT install_files


%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%doc COPYING README README.fr
%{_libdir}/nagios/plugins/perf2store


%changelog
* Thu Jul 30 2009 Aurelien Bompard <aurelien.bompard@c-s.fr>
- rename

* Mon Feb 23 2009  Thomas Burguiere <thomas.burguiere@c-s.fr>
- first creation of the RPM from debian archive
