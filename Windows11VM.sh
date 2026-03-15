# Download Windows 11 Disk Image (ISO) from
# https://www.microsoft.com/en-us/software-download/windows11
# Windows 11 ISO 7.75 GB
# virtio-win.iso 754 MB

if [ ! -f "$$HOME/iso/Win11_25H2_EnglishInternational_x64.iso" ]; then
  echo "$HOME/iso/Win11_25H2_EnglishInternational_x64.iso not found" >&2
  exit 1
fi
mkdir -p "win11_vm/tpm"
cp /usr/share/OVMF/OVMF_VARS_4M.ms.fd ~/win11_vm/OVMF_VARS_4M.ms.fd
wget https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso -O "$HOME/iso/virtio-win.iso"
sudo tee  /etc/apt/sources.list.d/swtpm.list<<EOF
deb [trusted=yes] https://ppa.launchpadcontent.net/stefanberger/swtpm-noble/ubuntu noble main
deb-src [trusted=yes] https://ppa.launchpadcontent.net/stefanberger/swtpm-noble/ubuntu noble main
EOF
sudo apt update
sudo apt install swtpm swtpm-tools -y
sudo apt install -f
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients virt-manager ovmf bridge-utils -y
qemu-img create -f qcow2 "$HOME/qcow2base/win11.qcow2" 100G
swtpm_setup \
  --tpm2 \
  --tpmstate "$HOME/win11_vm/tpm" \
  --lock-nvram
swtpm socket --tpm2 \
  --tpmstate dir="$HOME/win11_vm/tpm" \
  --ctrl type=unixio,path="/tmp/swtpm-sock" &
sudo qemu-system-x86_64 \
  -enable-kvm \
  -cpu host \
  -m 4G \
  -smp 4 \
  -machine q35 \
  -drive if=pflash,format=raw,readonly=on,file=/usr/share/OVMF/OVMF_CODE_4M.ms.fd \
  -drive if=pflash,format=raw,file="$HOME/win11_vm/OVMF_VARS_4M.ms.fd" \
  -drive file="$HOME/qcow2base/win11.qcow2",if=virtio \
  -cdrom "$$HOME/iso/Win11_25H2_EnglishInternational_x64.iso" \
  -netdev user,id=n1,hostfwd=tcp::3222-:22 \
  -device virtio-net-pci,netdev=n1 \
  -display sdl \
  -vga qxl \
  -device virtio-serial \
  -device virtserialport \
  -device virtio-balloon-pci \
  -chardev socket,id=chrtpm,path="/tmp/swtpm-sock" \
  -tpmdev emulator,id=tpm0,chardev=chrtpm \
  -device tpm-tis,tpmdev=tpm0 \
  -vnc :2
