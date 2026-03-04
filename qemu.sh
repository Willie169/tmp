mkdir -p ~/iso
cd ~/iso
wget https://cdimage.ubuntu.com/kubuntu/releases/24.04.3/release/kubuntu-24.04.4-desktop-amd64.iso
mkdir ~/kubuntu-vm
qemu-img create -f qcow2 ~/kubuntu-vm/kubuntu-vm.qcow2 50G
# Install
qemu-system-x86_64 \
  -enable-kvm \
  -cpu host \
  -m 4G \
  -smp 8 \
  -boot d \
  -cdrom ~/iso/kubuntu-24.04.4-desktop-amd64.iso \
  -drive file=~/kubuntu-vm/kubuntu-vm.qcow2,format=qcow2,if=virtio \
  -netdev user,id=n1,hostfwd=tcp::2222-:22,hostfwd=tcp::11434-:11434 \
  -device virtio-net-pci,netdev=n1 \
  -spice port=5930,disable-ticketing=on \
  -vga qxl \
  -device virtio-serial \
  -chardev spicevmc,id=vdagent,name=vdagent \
  -device virtserialport,chardev=vdagent,name=com.redhat.spice.0
# Run
qemu-system-x86_64 \
  -enable-kvm \
  -cpu host \
  -m 4G \
  -smp 8 \
  -boot c \
  -drive file=~/kubuntu-vm/kubuntu-vm.qcow2,format=qcow2,if=virtio \
  -netdev user,id=n1,hostfwd=tcp::2222-:22,hostfwd=tcp::11434-:11434 \
  -device virtio-net-pci,netdev=n1 \
  -spice port=5930,disable-ticketing=on \
  -vga qxl \
  -device virtio-serial \
  -chardev spicevmc,id=vdagent,name=vdagent \
  -device virtserialport,chardev=vdagent,name=com.redhat.spice.0