quickget windows 11
# If ISO download fails, download ISO manually from
# https://www.microsoft.com/en-us/software-download/windows11
# rename it to windows-11.iso and put it in ./windows-11
quickemu --vm windows-11.conf
# After installation, you no longer need
# ./windows-11/windows-11.iso
# You can use
# ./windows-11/disk.qcow2
# as base image, e.g.
cd windows-11
chmod -w disk.qcow2
qemu-img create -f qcow2 -b disk.qcow2 -F qcow2 office.qcow2
cd ..
cp windows-11.conf windows-11-office.conf
sed -i 's/disk.qcow2/office.qcow2/' windows-11-office.conf
# This can be booted with
quickemu --vm windows-11-office.conf
