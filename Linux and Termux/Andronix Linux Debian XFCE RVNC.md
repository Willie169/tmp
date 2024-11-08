# Andronix
## Source:
[https://github.com/AndronixApp/AndronixOrigin](https://github.com/AndronixApp/AndronixOrigin)
## Debian with XFCE desktop environment and connect it to RVNC viewer
### Installation of Debian and XFCE
```
pkg update -y && pkg install wget curl proot tar -y && wget https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/Installer/Debian/debian-xfce.sh -O debian-xfce.sh && chmod +x debian-xfce.sh &&  bash debian-xfce.sh
```
### Time zone setup
```
sudo ln -sf /usr/share/zoneinfo/Asia/Taipei /etc/localtime
```
### Noto CJK font
```
sudo apt install fonts-noto-cjk
```
### Turn on the computer (CLI)
```
./start-debian.sh
```
### VNC viewer
- Download and install RVNC viewer from Google Play Store
- Add a new connection with address "localhost:1" and name "Localhost" (or any other name)
- Run the following in Debian to connect VNC server to view GUI
```
vncserver-start
```
- Open RVNC viewer
- Click Localhost (the name set)
### Disconnect VNC server
```
vncserver-stop
```
### The file directory of the Debian computer
```
cd /data/data/com.termux/files/home/debian-fs
```
### Sound output
#### Installation 
```
pkg install wget && wget https://andronixos.sfo2.cdn.digitaloceanspaces.com/OS-Files/setup-audio.sh && chmod +x setup-audio.sh && ./setup-audio.sh
```
#### Usage
```
pulseaudio --start
```
## Debian CLI only
### Installation 
```
pkg update -y && pkg install wget curl proot tar -y && wget https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/Installer/Debian/debian.sh -O debian.sh && chmod +x debian.sh && bash debian.sh
```
## Uninstallation of Debian
```
wget https://raw.githubusercontent.com/AndronixApp/AndronixOrigin/master/Uninstall/Debian/UNI-debian.sh && chmod +x UNI-debian.sh && bash UNI-debian.sh
```
## Note
Ubuntu might have some issues in installations of packages after installed.