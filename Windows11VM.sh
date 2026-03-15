# Download Windows 11 Disk Image (ISO) from
# https://www.microsoft.com/en-us/software-download/windows11
WIN_ISO="$HOME/iso/Win11_25H2_EnglishInternational_x64.iso" # 7.75 GB
VIRTIO_ISO="$HOME/iso/virtio-win.iso" # 754 MB
QCOW2="$HOME/qcow2base/win11.qcow2"
TPM="$HOME/.tpm"

if [ ! -f "$WIN_ISO" ]; then
  echo "Windows ISO not found: $WIN_ISO" >&2
  exit 1
fi
mkdir -p "$HOME/iso"
mkdir -p "$TPM"
wget https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso -O "$VIRTIO_ISO"
sudo tee  /etc/apt/sources.list.d/swtpm.list<<EOF
deb [trusted=yes] https://ppa.launchpadcontent.net/stefanberger/swtpm-noble/ubuntu noble main
deb-src [trusted=yes] https://ppa.launchpadcontent.net/stefanberger/swtpm-noble/ubuntu noble main
EOF
sudo apt update
sudo apt install swtpm swtpm-tools -y
sudo apt install -f
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients virt-manager ovmf bridge-utils -y
qemu-img create -f qcow2 "$QCOW2" 100G
swtpm socket --tpm2 \
  --tpmstate dir="$TPM/tpm" \
  --ctrl type=unixio,path="$TPM/swtpm-sock" &
qemu-system-x86_64 \
  -enable-kvm \
  -cpu host \
  -m 4G \
  -smp 4 \
  -machine q35 \
  --boot loader=/usr/share/OVMF/OVMF_CODE.secboot.fd,loader_ro=yes,loader_type=pflash,nvram_template=/usr/share/OVMF/OVMF_VARS.ms.fd \
  -drive file="$QCOW2",if=virtio \
  -cdrom "$WIN_ISO" \
  -netdev user,id=n1,hostfwd=tcp::3222-:22 \
  -device virtio-net-pci,netdev=n1 \
  -display sdl,gl=on \
  -vga virtio \
  -device virtio-serial \
  -device virtserialport \
  -device virtio-balloon-pci \
  -chardev socket,id=chrtpm,path="$TPM/swtpm-sock" \
  -tpmdev emulator,id=tpm0,chardev=chrtpm \
  -device tpm-tis,tpmdev=tpm0 \
  -audiodev pipewire,id=audio0 \
  -device ich9-intel-hda \
  -device hda-duplex,audiodev=audio0 \
  -vnc :2
