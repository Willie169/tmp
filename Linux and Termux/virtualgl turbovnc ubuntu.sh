sudo apt install wget -y
wget https://sourceforge.net/projects/virtualgl/files/3.1/virtualgl_3.1_amd64.deb
sudo dpkg -i virtualgl_3.1_amd64.deb
rm virtualgl_3.1_amd64.deb*
wget https://sourceforge.net/projects/turbovnc/files/3.1/turbovnc_3.1_amd64.deb
sudo dpkg -i turbovnc_3.1_amd64.deb
rm turbovnc_3.1_amd64.deb*
wget https://sourceforge.net/projects/libjpeg-turbo/files/3.0.1/libjpeg-turbo-official_3.0.1_amd64.deb
sudo dpkg -i libjpeg-turbo-official_3.0.1_amd64.deb
rm libjpeg-turbo-official_3.0.1_amd64.deb*
sudo apt install libglu1-mesa mesa-utils xfce4 xfce4-goodies -y
# Use default gdm3 display manager
echo '#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
startxfce4 &' >> ~/.vnc/xstartup.turbovnc
chmod +x ~/.vnc/xstartup.turbovnc
vncpasswd
sudo vglserver_config
# 1, yes
sudo usermod --groups vglusers root
sudo usermod --groups vglusers $USER
mkdir -p /etc/opt/VirtualGL
sudo chgrp vglusers /etc/opt/VirtualGL
sudo chmod 750 /etc/opt/VirtualGL
## For Nvidia
## Use tty or ssh client
# sudo systemctl stop gdm
# sudo modprobe -r nvidia_uvm nvidia_drm nvidia_modeset nvidia
# sudo systemctl start gdm
## Log out and log in
# xauth merge /etc/opt/VirtualGL/vgl_xauth_key
# xdpyinfo -display :1
## Below is roughly the same as vncserver of tigervnc
# /opt/TurboVNC/bin/vncserver
## Source: https://www.google.com/amp/s/blog.gtwang.org/linux/nvidia-tesla-p40-virtualgl-vnc-remote-3d-rendering-server-installation/amp