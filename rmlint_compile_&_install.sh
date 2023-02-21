#!/bin/bash

# compile and install glib 3.3+
apt update
apt install -y build-essential gawk patchelf

mkdir -p /app/glibc-build /app/glibc-source
wget -c https://ftp.gnu.org/gnu/glibc/glibc-2.36.tar.gz
tar -zxvf glibc-2.36.tar.gz
rm glibc-2.36.tar.gz
mv glibc-2.36 /app/glibc-source

cd /app/glibc-build
bash /app/glibc-source/glibc-2.36/configure --prefix=/opt/glibc
make 
make install

patchelf --set-interpreter /app/glibc-build/ld-linux.so.2 --set-rpath /app/glibc-build/ scons

sleep 30

### Compile & Install rmLint latest Version

# Dependencies for rmlint 
apt-get install -y git scons python3-sphinx python3-nose gettext build-essential
# Optional dependencies for more features:
apt-get install -y libelf-dev libglib2.0-dev libblkid-dev libjson-glib-1.0 libjson-glib-dev
# Optional dependencies for the GUI:
#apt-get install python3-gi gir1.2-rsvg gir1.2-gtk-3.0 python-cairo gir1.2-polkit-1.0 gir1.2-gtksource-3.0

mkdir -p /app/rmlint-build
cd /app/rmlint-build

# Compilation
# Omit -b develop if you want to build from the stable master
git clone -b develop https://github.com/sahib/rmlint.git
cd rmlint/
scons config       # Look what features scons would compile
scons DEBUG=1      # Optional, build locally.
# Install (and build if necessary). For releases you can omit DEBUG=1
sudo scons DEBUG=1 --prefix=/usr install

# installed at /usr/bin/rmlint