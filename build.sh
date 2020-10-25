#!/bin/sh
# Original: https://gist.github.com/fumiyas/b4aaee83e113e061d1ee8ab95b35608b

set -u
set -e
umask 0077

prefix="/opt/openssh"
top="$(pwd)"
root="$top/root"
build="$top/build"

export CPPFLAGS="-I$root/include -L. -fPIC"

rm -rf "$root" "$build"
mkdir -p "$root" "$build"

gzip -dc dist/zlib-*.tar.gz |(cd "$build" && tar xf -)
cd "$build"/zlib-*
./configure --prefix="$root" --static
make
make install
cd "$top"

gzip -dc dist/openssl-*.tar.gz |(cd "$build" && tar xf -)
cd "$build"/openssl-*
./config --prefix="$root" no-shared
make
make install
cd "$top"

gzip -dc dist/openssh-*.tar.gz |(cd "$build" && tar xf -)
cd "$build"/openssh-*
cp -p "$root"/lib/*.a .
[ -f sshd_config.orig ] || cp -p sshd_config sshd_config.orig
sed \
  -e 's/^#\(PubkeyAuthentication\) .*/\1 yes/' \
  -e '/^# *Kerberos/d' \
  -e '/^# *GSSAPI/d' \
  -e 's/^#\([A-Za-z]*Authentication\) .*/\1 no/' \
  sshd_config.orig \
  >sshd_config \
;
LIBS="-ldl -lpthread"
./configure --prefix="$root" --with-privsep-user=nobody --with-privsep-path="$prefix/var/empty"
make
#make install
cd "$top"