sudo apt install openssh-server -y
sudo systemctl enable ssh
sudo systemctl start ssh
sudo ufw enable
sudo ufw allow ssh

# config

sudo nano /etc/ssh/sshd_config