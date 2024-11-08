Fail

Install:
```
pkg install proot debootstrap qemu-user-x86-64
mkdir ~/debian-amd64
cd ~/debian-amd64
debootstrap --arch amd64 stable ./debian-amd64 http://deb.debian.org/debian/
rm -rf ./debian-amd64/proc ./debian-amd64/sys ./debian-amd64/dev
unset LD_PRELOAD
wget https://deb.debian.org/debian/pool/main/d/dpkg/dpkg_1.22.11_amd64.deb
mv dpkg_1.22.11_amd64.deb ./debian-amd64/tmp
wget http://deb.debian.org/debian/pool/main/a/apt/apt_2.6.1_amd64.deb
mv apt_2.6.1_amd64.deb ./debian-amd64/tmp
```
Enter:
```
proot -r ./debian-amd64 -b /proc -b /sys -b /dev -q qemu-x86_64 /bin/bash
```
Setup:
```
cd /tmp
ar x dpkg_1.20.0_amd64.deb
dpkg -i /tmp/apt_2.6.1_amd64.deb
echo "deb http://deb.debian.org/debian/ stable main" > /etc/apt/sources.list
```
Now you can use apt