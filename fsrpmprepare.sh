#!/bin/bash
# This script prepares two files(spec and tar.gz) for F# RPM.
# You should run this under clean directory.

# git clone F# source
echo '*** Getting F# source from GitHub. Please wait. ***'
git clone https://github.com/fsharp/fsharp

echo '*** Renaming directory and writing spec file. ***'
cd fsharp
# get last commit unixtime
fsgitut=`git log --pretty=format:"%ct" |head -1`
# unixtime to YYYYMMDD
fsgitdate=`date --date="@$fsgitut" +%Y%m%d`
# set target folger name
fstargetname=fsharp-git$fsgitdate
cd ..
mv fsharp $fstargetname

# write spec file
cat<< 'EOF' |perl -pe "s/_GITDATEREPLACE_/$fsgitdate/" >fsharp.spec

%define gitdate _GITDATEREPLACE_

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

EOF

# create tar.gz
echo '*** Creating tar.gz. Please wait. ***'
tar -cz $fstargetname>$fstargetname.tar.gz

# finish
cat <<'EOF'
*** Done! ***
Move spec-file and tar.gz-file to appropriate location.
(spec to %_specdir, tar.gz to %_sourcedir)
And you are able to build SRPM and RPM of F#!
EOF
