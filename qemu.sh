mkdir -p ~/iso
cd ~/iso
wget https://cdimage.ubuntu.com/kubuntu/releases/24.04.3/release/kubuntu-24.04.4-desktop-amd64.iso
mkdir ~/kubuntu-vm
qemu-img create -f qcow2 ~/kubuntu-vm/kubuntu-vm.qcow2 50G
sudo ufw insert 1 deny from 10.0.3.0/24
sudo ufw insert 1 allow from 10.0.3.0/24 to any port 11434
# Install
qemu-system-x86_64 \
  -enable-kvm \
  -cpu host \
  -m 4G \
  -smp $(nproc) \
  -boot d \
  -cdrom ~/iso/kubuntu-24.04.4-desktop-amd64.iso \
  -drive file=~/kubuntu-vm/kubuntu-vm.qcow2,format=qcow2,if=virtio \
  -netdev user,id=n1,net=10.0.3.0/24,hostfwd=tcp::2222-:22 \
  -device virtio-net-pci,netdev=n1 \
  -display sdl,gl=on \
  -vga virtio \
  -device virtio-serial \
  -vnc :2,to=5
# Run
qemu-system-x86_64 \
  -enable-kvm \
  -cpu host \
  -m 4G \
  -smp $(nproc) \
  -boot c \
  -drive file=~/kubuntu-vm/kubuntu-vm.qcow2,format=qcow2,if=virtio \
  -netdev user,id=n1,net=10.0.3.0/24,hostfwd=tcp::2222-:22 \
  -device virtio-net-pci,netdev=n1 \
  -display sdl,gl=on \
  -vga virtio \
  -device virtio-serial \
  -vnc :2,to=5
## Connect SPICE
remote-viewer spice://127.0.0.1:5930
