# OpenClaw in QEMU Kubuntu VM

## ISO

```
source ~/.bashrc.d/50-functions.sh
mkdir -p ~/iso
```
It may be faster to download via torrent instead.
```
cd ~/iso
wget https://cdimage.ubuntu.com/kubuntu/releases/24.04.3/release/kubuntu-24.04.4-desktop-amd64.iso
```

## OS Base Image

```
source ~/.bashrc.d/50-functions.sh
mkdir -p ~/qcow2base
qemu-img create -f qcow2 ~/qcow2base/kubuntu-24.04.4-desktop-amd64-base.qcow2 50G
myqemu_install ~/iso/kubuntu-24.04.4-desktop-amd64.iso ~/qcow2base/kubuntu-24.04.4-desktop-amd64-base.qcow2 10.0.2.0
```
Install OS in it.

In host, run:
```
chmod -w ~/qcow2base/kubuntu-24.04.4-desktop-amd64-base.qcow2
```

## Claw Base Image

```
source ~/.bashrc.d/50-functions.sh
qemu-img create -f qcow2 -b ~/qcow2base/kubuntu-24.04.4-desktop-amd64-base.qcow2 -F qcow2 ~/qcow2base/claw-kubuntu-base.qcow2
myqemu_run ~/qcow2base/claw-kubuntu-base.qcow2 10.0.3.0
```
Run the commands below in it.
```
sudo apt update
sudo apt install openssh-server -y
sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo mkdir -p /run/sshd
sudo chmod 0755 /run/sshd
sudo chown root:root /run/sshd
sudo systemctl enable --now ssh
yes | sudo ufw enable
sudo ufw allow ssh
```
SSH can be used since now.
```
sudo apt install plasma-workspace-wayland -y
```
Log out, select `Plasma (Wayland)` in the down left corner of the login page, and login.
```
sudo apt upgrade -y
sudo apt install bash build-essential bzip2 cmake curl dbus dnsutils fcitx5 fcitx5-* gcc git gnupg gzip iproute2 make nano netcat-openbsd ninja-build openssl python-is-python3 python3 python3-pip python3-venv socat tar update-manager-core vim wget wl-clipboard -y
sudo mkdir -p /usr/share/codeblocks/docs
im-config -n fcitx5
cat > ~/.xprofile <<'EOF'
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export INPUT_METHOD=fcitx
EOF
source ~/.xprofile
sudo add-apt-repository ppa:zhangsongcui3371/fastfetch -y
sudo apt install fastfetch -y
sudo add-apt-repository ppa:mozillateam/ppa -y
echo 'Package: firefox*
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001

Package: firefox*
Pin: release o=Ubuntu
Pin-Priority: -1' | sudo tee /etc/apt/preferences.d/firefox
sudo rm -f /etc/apparmor.d/usr.bin.firefox
sudo rm -f /etc/apparmor.d/local/usr.bin.firefox
sudo apt install firefox --allow-downgrades -y
sudo ln -sf /etc/apparmor.d/firefox /etc/apparmor.d/disable/
sudo apparmor_parser -R /etc/apparmor.d/firefox
echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:$(lsb_release -cs)";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-mozilla
sudo add-apt-repository ppa:xtradeb/apps -y
echo 'Package: chromium*
Pin: release o=LP-PPA-xtradeb-apps
Pin-Priority: 1001

Package: chromium*
Pin: release o=Ubuntu
Pin-Priority: -1' | sudo tee /etc/apt/preferences.d/chromium
sudo apt update
sudo apt install chromium chromium-driver chromium-l10n -y
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources
sudo apt update
sudo apt install brave-browser -y
git clone --depth=1 https://github.com/Willie169/vimrc.git ~/.vim_runtime && sh ~/.vim_runtime/install_awesome_vimrc.sh
cat >> ~/.bashrc <<EOF

update_vimrc() {
  (
  cd ~/.vim_runtime
  git reset --hard
  git clean -d --force
  git pull --rebase
  python3 update_plugins.py
  )
}

export OLLAMA_API_KEY=ollama-local
EOF
bash -c 'curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash'
source ~/.bashrc
nvm install 24
corepack enable yarn
corepack enable pnpm
npm install -g http-server
mkdir -p ~/.config/systemd/user
cat > ~/.config/systemd/user/litellm-forward.service <<EOF
[Unit]
Description=Forward localhost:4000 to 10.0.3.2:4000

[Service]
ExecStart=/usr/bin/socat TCP-LISTEN:4000,fork TCP:10.0.3.2:4000
Restart=always

[Install]
WantedBy=default.target
EOF
cat > ~/.config/systemd/user/ollama-forward.service <<EOF
[Unit]
Description=Forward localhost:11434 to 10.0.3.2:11434

[Service]
ExecStart=/usr/bin/socat TCP-LISTEN:11434,fork TCP:10.0.3.2:11434
Restart=always

[Install]
WantedBy=default.target
EOF
systemctl --user daemon-reload
systemctl --user enable --now litellm-forward.service
systemctl --user enable --now ollama-forward.service
```
Configure browsers etc. in it, and then
```
sudo poweroff
```
In host, run:
```
chmod -w ~/qcow2base/claw-kubuntu-base.qcow2
sudo ufw insert 1 deny from 10.0.3.0/24
sudo ufw insert 1 allow from 10.0.3.0/24 to any port 11434
sudo ufw insert 1 allow from 10.0.3.0/24 to any port 4000
```

## Claw Image

```
source ~/.bashrc.d/50-functions.sh
mkdir -p ~/claw-kubuntu
qemu-img create -f qcow2 -b ~/qcow2base/claw-kubuntu-base.qcow2 -F qcow2 ~/claw-kubuntu/claw-kubuntu.qcow2
myqemu_run ~/claw-kubuntu/claw-kubuntu.qcow2 10.0.3.0
```
Install OpenClaw in it.
```
curl -fsSL https://openclaw.ai/install.sh | bash -s -- --no-onboard
openclaw doctor --fix
openclaw config set gateway.mode "local"
openclaw gateway stop
openclaw gateway start
```

