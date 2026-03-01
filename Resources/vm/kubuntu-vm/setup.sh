bash <<'EOF'
set -e
f=/etc/apt/sources.list.d/ubuntu.sources
if [ -f "$f" ] && grep -q "^Types:.*deb" "$f"; then
  sudo sed -i 's/^Types: *deb.*/Types: deb deb-src/' "$f"
fi
EOF
TMP=$(mktemp)
if sudo test -f "/etc/sddm.conf"; then
  sudo cat "/etc/sddm.conf" > "$TMP"
fi
sed -i '/User=/d' "$TMP"
sed -i '/Session=/d' "$TMP"
if ! grep -q "^\[Autologin\]" "$TMP"; then
  printf "\n[Autologin]\n" >> "$TMP"
fi
sed -i "/^\[Autologin\]/a User=${SUDO_USER:-$(logname 2>/dev/null || true)}\nSession=plasmawayland" "$TMP"
sudo tee "/etc/sddm.conf" < "$TMP" >/dev/null
if dpkg -s kwalletmanager &>/dev/null; then
  if [[ ! -f ~/.config/kwalletrc ]]; then
    touch ~/.config/kwalletrc
  else
    sed -i '/Enabled=/d' ~/.config/kwalletrc
  fi
  if ! grep -q "^\[Wallet\]" ~/.config/kwalletrc; then
    printf "\n[Wallet]\n" >> ~/.config/kwalletrc
  fi
  sed -i "/^\[Wallet\]/a Enabled=false" ~/.config/kwalletrc
fi
sudo tee /etc/systemd/resolved.conf >/dev/null <<'EOF'
[Resolve]
DNS=1.1.1.1 1.0.0.1
FallbackDNS=2606:4700:4700::1111 2606:4700:4700::1001 94.140.14.140 94.140.14.141 2a10:50c0::1:ff 2a10:50c0::2:ff
EOF
sudo systemctl restart systemd-resolved
sudo mkdir -p /etc/apt/keyrings
mkdir -p ~/.local/bin
mkdir -p ~/.local/share/applications
mkdir -p ~/Desktop
mkdir -p ~/.config/systemd/user
sudo apt update
sudo apt purge fcitx* -y </dev/null
sudo apt upgrade -y
sudo apt install bash curl dbus dnsutils fcitx5 fcitx5-* gcc git gnupg iproute2 jq nano netcat-openbsd openssh-server openssl pipewire plasma-workspace-wayland python-is-python3 python3 python3-pip python3-venv socat tar update-manager-core vim wget wl-clipboard -y
sudo add-apt-repository ppa:mozillateam/ppa -y
echo 'Package: firefox*
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001

Package: firefox*
Pin: release o=Ubuntu
Pin-Priority: -1' | sudo tee /etc/apt/preferences.d/firefox
sudo rm -f /etc/apparmor.d/usr.bin.firefox
sudo rm -f /etc/apparmor.d/local/usr.bin.firefox
sudo systemctl stop var-snap-firefox-common-*.mount 2>/dev/null || true
sudo systemctl disable var-snap-firefox-common-*.mount 2>/dev/null || true
sudo systemctl disable snap-firefox*.mount 2>/dev/null || true
sudo snap remove firefox 2>/dev/null || true
sudo apt install firefox --allow-downgrades -y </dev/null
sudo ln -sf /etc/apparmor.d/firefox /etc/apparmor.d/disable/
sudo apparmor_parser -R /etc/apparmor.d/firefox
sudo rm /var/lib/snapd/desktop/applications/firefox*.desktop 2>/dev/null || true
sudo rm /var/lib/snapd/inhibit/firefox.lock 2>/dev/null || true
echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:$(lsb_release -cs)";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-mozilla
im-config -n fcitx5
cat > ~/.xprofile <<'EOF'
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export INPUT_METHOD=fcitx
export SDL_IM_MODULE=fcitx
export GLFW_IM_MODULE=ibus
EOF
sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo mkdir -p /run/sshd
sudo chmod 0755 /run/sshd
sudo chown root:root /run/sshd
sudo systemctl enable ssh
yes | sudo ufw enable
sudo ufw allow ssh
sudo ufw reload
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources
sudo apt update
sudo apt install brave-browser -y
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
source ~/.bashrc
nvm install --lts
corepack enable npm
