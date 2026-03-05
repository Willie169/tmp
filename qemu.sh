source ~/.bashrc.d/50-functions.sh
mkdir -p ~/iso
cd ~/iso
wget https://cdimage.ubuntu.com/kubuntu/releases/24.04.3/release/kubuntu-24.04.4-desktop-amd64.iso # recommended to download via torrent instead
mkdir -p ~/qcow2base
qemu-img create -f qcow2 ~/qcow2base/kubuntu-24.04.4-desktop-amd64-base.qcow2 50G
myqemu_install ~/iso/kubuntu-24.04.4-desktop-amd64.iso ~/qcow2base/kubuntu-24.04.4-desktop-amd64-base.qcow2 10.0.2.0
# install OS
chmod -w ~/qcow2base/kubuntu-24.04.4-desktop-amd64-base.qcow2
mkdir ~/claw-kubuntu
qemu-img create -f qcow2 -b ~/qcow2base/kubuntu-24.04.4-desktop-amd64-base.qcow2 ~/claw-kubuntu/claw-kubuntu.qcow2
sudo ufw insert 1 deny from 10.0.3.0/24
sudo ufw insert 1 allow from 10.0.3.0/24 to any port 11434
myqemu_run ~/claw-kubuntu/claw-kubuntu.qcow2 10.0.3.0
