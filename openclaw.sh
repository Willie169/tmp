# myqemu_run ~/claw-kubuntu/claw-kubuntu.qcow2 10.0.3.0
sudo apt update
sudo apt install bash build-essential cmake curl git openssh-server neovim python-is-python3 python3-all-dev python3-neovim python3-pip python3-venv socat vim wget -y
sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo mkdir -p /run/sshd
sudo chmod 0755 /run/sshd
sudo chown root:root /run/sshd
sudo systemctl enable ssh
yes | sudo ufw enable
sudo ufw allow ssh
sudo apt install plasma-workspace-wayland -y
# logout, select in the down left corner of the login page, choose Plasma (Wayland), and login
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
sudo git clone --depth=1 https://github.com/Willie169/vimrc.git /opt/vim_runtime && sudo sh /opt/vim_runtime/install_awesome_parameterized.sh /opt/vim_runtime --all
mkdir -p ~/.config/nvim/lua/config
mkdir -p ~/.config/nvim/lua/plugins
cat > ~/.config/nvim/init.lua <<'EOF'
vim.cmd("set runtimepath^=~/.vim runtimepath+=~/.vim/after")
vim.cmd("let &packpath = &runtimepath")
vim.cmd("source ~/.vimrc")
require("config.lazy")
EOF
cat > ~/.config/nvim/lua/config/lazy.lua <<'EOF'
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
EOF
cat > ~/.config/nvim/lua/plugins/jupytext.lua <<'EOF'
return {
    {
        'goerz/jupytext.nvim',
        version = '0.2.0',
        opts = {
            jupytext = 'jupytext',
            format = "auto",
            update = true,
            sync_patterns = { '*.md', '*.py', '*.jl', '*.R', '*.Rmd', '*.qmd' },
            autosync = true,
            handle_url_schemes = true,
        }
    }
}
EOF
bash -c 'curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash'
source ~/.bashrc
nvm install 24
echo 'export OLLAMA_API_KEY=ollama-local' >> ~/.bashrc
source ~/.bashrc
mkdir -p ~/.config/systemd/user
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
systemctl --user enable --now ollama-forward.service
curl -fsSL https://openclaw.ai/install.sh | bash
curl -fsSL https://openclaw.ai/install.sh | bash
openclaw doctor --fix

