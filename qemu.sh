source ~/.bashrc.d/50-functions.sh
mkdir -p ~/iso
cd ~/iso
wget https://cdimage.ubuntu.com/kubuntu/releases/24.04.3/release/kubuntu-24.04.4-desktop-amd64.iso
mkdir ~/kubuntu-vm
qemu-img create -f qcow2 ~/kubuntu-vm/kubuntu-vm.qcow2 50G
sudo ufw insert 1 deny from 10.0.3.0/24
sudo ufw insert 1 allow from 10.0.3.0/24 to any port 11434
myqemu_install \
  ~/iso/kubuntu-24.04.4-desktop-amd64.iso \
  ~/kubuntu-vm/kubuntu-vm.qcow2 \
  10.0.3.0
myqemu_run \
  ~/kubuntu-vm/kubuntu-vm.qcow2 \
  10.0.3.0
