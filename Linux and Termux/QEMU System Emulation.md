## QEMU System Emulation
### Install QEMU
```
pkg install qemu-system-x86_64 qemu-utils qemu-common openssl
```
### ISO Image method
This method may encounter some issues like GRUB not showing on CLI or stuck at 79% or 83% of the installation of the base system, so qcow2 method is recommended.
#### Prepare the ISO Image
Here takes Debian for example. Change the URL to the download link of the ISO you want:
```
wget https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.7.0-amd64-netinst.iso
```
#### Create a Virtual Disk Image Where the Operating System Will Be Installed
```
qemu-img create -f qcow2 debian_amd64.qcow2 20G
```
Change the `debian_amd64.qcow2` to the file name you want. `20G` indicates 20GB disk image. You can adjust the size as needed.
#### Install VM with CLI
```
nano qemuInstall.sh
```
Copy below and paste:
```
qemu-system-x86_64 -machine q35 \
-drive if=pflash,format=raw,read-only=on,file=$PREFIX/share/qemu/edk2-x86_64-code.fd \
-m 2G \
-accel tcg,thread=multi \
-smp sockets=1,cores=4,threads=1 \
-cpu qemu64 \
-vga std \
-netdev user,id=n1,hostfwd=tcp::2222-:22 -device virtio-net,netdev=n1 \
-device intel-hda \
-device qemu-xhci \
-boot d \
-boot menu=on \
-drive file=debian_amd64.qcow2 \
-nographic \
-serial mon:stdio \
-display none \
-cdrom ~/debian-12.7.0-amd64-DVD-1.iso
```
Change the `debian_amd64.qcow2` as the real file name. Change the `debian-12.7.0-amd64-netinst.iso` to your ISO path. `20G` indicates 20GB disk image. You can adjust the size as needed.
```
chmod +x qemuInstall.sh
```
#### Install VM with GUI
```
nano qemuInstall.sh
```
Copy below and paste:
```
qemu-system-x86_64 -machine q35 \
-drive if=pflash,format=raw,read-only=on,file=$PREFIX/share/qemu/edk2-x86_64-code.fd \
-m 2G \
-accel tcg,thread=multi \
-smp sockets=1,cores=4,threads=1 \
-cpu qemu64 \
-vga std \
-netdev user,id=n1,hostfwd=tcp::2222-:22 -device virtio-net,netdev=n1 \
-device intel-hda \
-device usb-tablet \
-boot menu=on \
-drive file=debian_amd64.qcow2 \
--vnc :0 \
-cdrom ~/debian-12.7.0-amd64-netinst.iso
```
Change the `debian_amd64.qcow2` as the real file name. Change the `debian-12.7.0-amd64-netinst.iso` to your ISO path. `20G` indicates 20GB disk image. You can adjust the size as needed. Change the `--vnc` to the port you want to use. Connect to the VNC server and follow the screen guide to install.
```
chmod +x qemuInstall.sh
```
#### Boost with CLI
```
nano qemuCli.sh
```
Copy and paste:
```
qemu-system-x86_64 -machine q35 \
-drive if=pflash,format=raw,read-only=on,file=$PREFIX/share/qemu/edk2-x86_64-code.fd \
-m 2G \
-accel tcg,thread=multi \
-smp sockets=1,cores=4,threads=1 \
-cpu qemu64 \
-vga std \
-netdev user,id=n1,hostfwd=tcp::2222-:22 -device virtio-net,netdev=n1 \
-device intel-hda \
-device usb-tablet \
-boot menu=on \
-drive file=debian_amd64.qcow2 \
-serial mon:stdio \
-display none
```
Change the `debian_amd64.qcow2` as the real file name. `20G` indicates 20GB disk image. You can adjust the size as needed. 
#### Boost with GUI
```
nano qemuGui.sh
```
Copy and paste:
```
qemu-system-x86_64 -machine q35 \
-drive if=pflash,format=raw,read-only=on,file=$PREFIX/share/qemu/edk2-x86_64-code.fd \
-m 2G \
-accel tcg,thread=multi \
-smp sockets=1,cores=4,threads=1 \
-cpu qemu64 \
-vga std \
-netdev user,id=n1,hostfwd=tcp::2222-:22 -device virtio-net,netdev=n1 \
-device intel-hda \
-device usb-tablet \
-boot menu=on \
-drive file=debian_amd64.qcow2 \
--vnc :0
```
Change the `debian_amd64.qcow2` as the real file name. `20G` indicates 20GB disk image. You can adjust the size as needed. Change the `--vnc` to the port you want to use. 
### qcow2 Cloud Image Method
#### Prepare the qcow2 Image
```
wget https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-nocloud-amd64.qcow2
```
Here takes Debian for example. Change the URL to the download link of the qcow2 you want.
#### Boost with CLI
```
qemu-system-x86_64 -m 2G \
-drive file=debian-12-nocloud-amd64.qcow2,format=qcow2 \
-nographic \
-serial mon:stdio \
-display none \
-netdev user,id=net0,hostfwd=tcp::2222-:22 \
-device e1000,netdev=net0
```
Change `debian-12-nocloud-amd64.qcow2` to the name of your qcow2 file. `20G` indicates 20GB disk image. You can adjust the size as needed. Change the port `2222` to the port you want to use for tcp.
#### Boost with GUI
```
qemu-system-x86_64 -m 2G \
-drive file=debian-12-nocloud-amd64.qcow2,format=qcow2 \
-vnc :0
-netdev user,id=net0,hostfwd=tcp::2222-:22 \
-device e1000,netdev=net0
```
Change `debian-12-nocloud-amd64.qcow2` to the name of your qcow2 file. `20G` indicates 20GB disk image. You can adjust the size as needed. Change the `--vnc` to the port you want to use. Change the port `2222` to the port you want to use for tcp.
#### Login
In Debian example, when you see:
```
Debian GNU/Linux 12 localhost ttyS0

localhost login:
```
In the first time, type `root` and you will be logged in without a password. \
You can set password latter by:
```
passwd
```
Set a password at least 4 letters long.\
If you don't set password, type `root` and you will be logged in without a password.
### Note
Remember to update before `apt` installing.
```
apt update && apt upgrade
```
### Resize Disk Space
Outside VM:
```
qemu-img resize debian-12-nocloud-amd64.qcow2 +30G
```
Change `debian-12-nocloud-amd64.qcow2` to the name of your qcow2 file. `+20G` indicates increasing 20GB disk image. You can adjust the size as needed. \
Inside VM:
```
sudo apt install parted e2fsprogs
sudo parted /dev/sda
print
fix
resizepart 1 100%
quit
sudo resize2fs /dev/sda1
```
### Check
#### Check Info
Outside VM:
```
qemu-img info debian-12-nocloud-amd64.qcow2
```
#### Check Disk
Inside VM:
```
df -h
```
and for partition:
```
lsblk
```
### Optional: SSH
Start a SSH server in QEMU VM and start a client in another Termux session.
### Source
- [https://ivonblog.com/posts/termux-qemu-system-linux/](https://ivonblog.com/posts/termux-qemu-system-linux/)
- [https://www.qemu.org/docs/master/index.html](https://www.qemu.org/docs/master/index.html)
- [https://www.debian.org/distrib/index.en.html](https://www.debian.org/distrib/index.en.html)
- [https://chatgpt.com/](https://chatgpt.com/)
- [https://www.reddit.com/r/debian/s/s871vXlGRI](https://www.reddit.com/r/debian/s/s871vXlGRI)