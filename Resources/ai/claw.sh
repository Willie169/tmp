sudo apt update
sudo apt install openssh-server -y
sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo mkdir -p /run/sshd
sudo chmod 0755 /run/sshd
sudo chown root:root /run/sshd
sudo systemctl enable --now ssh
yes | sudo ufw enable
sudo ufw allow ssh
# ssh can be used since now
USER_NAME=${SUDO_USER:-$(logname 2>/dev/null || true)}
CONF="/etc/sddm.conf"
TMP=$(mktemp)
if sudo test -f "$CONF"; then
  sudo cat "$CONF" > "$TMP"
fi
sed -i '/User=/d' "$TMP"
if ! grep -q "^\[Autologin\]" "$TMP"; then
  printf "\n[Autologin]\n" >> "$TMP"
fi
sed -i "/^\[Autologin\]/a User=$USER_NAME" "$TMP"
sudo tee "$CONF" < "$TMP" >/dev/null
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
sudo apt install software-properties-common -y
sudo add-apt-repository universe -y
sudo add-apt-repository multiverse -y
sudo add-apt-repository restricted -y
sudo apt upgrade -y
sudo apt install bash build-essential bzip2 cmake curl dbus dnsutils fcitx5 fcitx5-* flatpak gnome-keyring gcc git gnupg gzip iproute2 make nano netcat-openbsd ninja-build openssl python-is-python3 python3 python3-pip python3-venv socat tar update-manager-core vim wget wl-clipboard -y
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
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources
sudo apt update
sudo apt install brave-browser -y
bash -c 'curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash'
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install --lts
corepack enable yarn
corepack enable pnpm
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
curl -fsSL https://openclaw.ai/install.sh | bash -s -- --no-onboard
openclaw doctor --fix
openclaw config set gateway.mode "local"
openclaw gateway stop
openclaw gateway start
cat >> ~/.bashrc <<'EOF'

export OLLAMA_API_KEY='ollama-local'
EOF
# Export LITELLM_API_KEY as your LiteLLM virtual key in ~/.bashrc
source ~/.bashrc
openclaw onboard --auth-choice litellm-api-key

