cd ~
sudo apt update
sudo apt install wget -y
wget --tries=100 --retry-connrefused --waitretry=5 https://raw.githubusercontent.com/Willie169/tmp/refs/heads/main/kubuntu-vm/setup.sh
chmod +x setup.sh
./setup.sh
