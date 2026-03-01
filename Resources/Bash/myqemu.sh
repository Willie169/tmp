myqemu_install() {
  local iso="$1"
  local drive="$2"
  local addr="$3"
  shift 3
  qemu-system-x86_64 \
    -enable-kvm \
    -cpu host \
    -m 4G \
    -smp $(nproc) \
    -boot d \
    -cdrom "$iso" \
    -drive file="$drive",format=qcow2,if=virtio \
    -netdev user,id=n1,net="$addr"/24,hostfwd=tcp::2222-:22 \
    -device virtio-net-pci,netdev=n1 \
    -display sdl,gl=on \
    -vga virtio \
    -device virtio-serial \
    -device virtserialport \
    -device virtio-balloon-pci \
    -audiodev pipewire,id=audio0 \
    -device ich9-intel-hda \
    -device hda-duplex,audiodev=audio0 \
    -vnc :2 "$@"
}

myqemu_run() {
  local drive="$1"
  local addr="$2"
  shift 2
  qemu-system-x86_64 \
    -enable-kvm \
    -cpu host \
    -m 4G \
    -smp $(nproc) \
    -boot c \
    -drive file="$drive",format=qcow2,if=virtio \
    -netdev user,id=n1,net="$addr"/24,hostfwd=tcp::2222-:22 \
    -device virtio-net-pci,netdev=n1 \
    -display sdl,gl=on \
    -vga virtio \
    -device virtio-serial \
    -device virtserialport \
    -device virtio-balloon-pci \
    -audiodev pipewire,id=audio0 \
    -device ich9-intel-hda \
    -device hda-duplex,audiodev=audio0 \
    -vnc :2 "$@"
}

