## OpenSSH with Linux or Termux: Secure Remote Access
### Introduction of SSH and OpenSSH
SSH provides a secure way for accessing remote hosts and replaces tools such as telnet, rlogin, rsh, ftp. \
OpenSSH (also known as OpenBSD Secure Shell) is a suite of secure networking utilities based on the Secure Shell (SSH) protocol, which provides a secure channel over an unsecured network in a client–server architecture.\
Default SSH port in **Termux** is `8022`.\
Default SSH port in Linux is usually `22`.
### OpenSSH Server in Linux
#### Install and Setup
```
sudo apt install openssh-server
sudo systemctl enable --now ssh
```
#### Edit Configuration 
```
sudo nano /etc/ssh/sshd_config
```
Change the line:
```
#Port 22
```
to:
```
Port 2222
```
You can change the port `2222` to the port you want. Note that you may need to set the ports that VM can use when booting VM if you are in a VM.\
Change the line:
```
#PermitRootLogin prohibit-password
```
to:
```
PermitRootLogin yes
```
if you want to permit login as root.
#### Start 
```
sudo service ssh start
```
#### Restart  
```
sudo service ssh restart
```
#### Stop 
```
sudo service ssh stop
```
#### Disable 
```
sudo systemctl disable ssh
```
#### Enable 
```
sudo systemctl enable ssh
```
#### Check Status
```
sudo service ssh status
```
#### Allow Localhost Connection 
```
nano /etc/hosts .deny
```
Delete all lines in it.
### OpenSSH Server in Termux 
#### Install
```
apt install openssh
```
#### Start
```
sshd
```
#### Stop
```
pkill sshd
```
### OpenSSH Client in Linux or Termux
#### Install in Linux
```
sudo apt install openssh-client
```
#### Install in Termux 
```
apt install openssh
```
#### Run
```
ssh root@localhost
```
Change the `root@localhost` to the actual user name and address. Port will be set as default.\
Run with port specified:
```
ssh root@localhost -p 2222
```
Change `2222` to the port of the server.
#### Delete Key
You need to delete the original key if the server is reset.
```
ssh-keygen -R [localhost]:2222
```
Change `[localhost]:2222` to the actual address and port of the server.
### Further Readings and References about OpenSSH with Linux and Termux
- [https://www.openssh.com/](https://www.openssh.com/)
- [https://ivonblog.com/posts/termux-qemu-system-linux/](https://ivonblog.com/posts/termux-qemu-system-linux/)
- [https://wiki.termux.com/wiki/Remote_Access](https://wiki.termux.com/wiki/Remote_Access).