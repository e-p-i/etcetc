
%define gitdate 20110919

Name:		fsharp
Version:	2.0.0.0
Release:	0.git%{gitdate}%{?dist}
License:	Apache License, 2.0
URL:		https://github.com/fsharp/fsharp
Source0:	%{name}-git%{gitdate}.tar.gz
BuildRequires:	mono-devel
Requires:	mono-core
Summary:	The F# Compiler and Interpriter
Group:		Development/Languages
# Mono only available on these:
ExclusiveArch: %ix86 x86_64 ppc ppc64 ia64 %{arm} sparcv9 alpha s390x

%define debug_package %{nil}

%description

This package contains the F# compiler, interpriter and core library for Mono.
If you want to use compiler, use fsharpc or fsharpc2(for Framework 2.0).
If you want to use interpriter, use fsharpi or fsharpi2(for Framework 2.0).

%prep
%setup -q -n %{name}-git%{gitdate}
autoconf

%build
%configure --prefix=%{_prefix}
make

%install
make DESTDIR=%{buildroot} install

%files
%defattr(-, root, root)
%doc LICENSE README README.html
%{_prefix}/bin/*
%{_prefix}/lib/mono/2.0/*
%{_prefix}/lib/mono/4.0/*
%{_prefix}/lib/mono/gac/*

%changelog
* Sat Dec 28 2011 Katamine Kentaro <gepiml1818@gmail.com> - 2.0.0.0
- Init spec file.

