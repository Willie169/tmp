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
sudo apt install libglu1-mesa mesa-utils -y
echo '#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
export XKL_XMODMAP_DISABLE=1
export XDG_CURRENT_DESKTOP="GNOME-Flashback:Unity"
export XDG_MENU_PREFIX="gnome-flashback-"
gnome-session --session=gnome-flashback-metacity --disable-acceleration-check
' >> ~/.vnc/xstartup.turbovnc
chmod +x ~/.vnc/xstartup.turbovnc
sudo vglserver_config
sudo usermod --groups vglusers root
sudo usermod --groups vglusers $USER
mkdir -p /etc/opt/VirtualGL
chgrp vglusers /etc/opt/VirtualGL
chmod 750 /etc/opt/VirtualGL
## Log out and log in
# xauth merge /etc/opt/VirtualGL/vgl_xauth_key
# xdpyinfo -display :0
## Below is roughly the same as vncserver of tigervnc
# /opt/TurboVNC/bin/vncserver
## Source: https://www.google.com/amp/s/blog.gtwang.org/linux/nvidia-tesla-p40-virtualgl-vnc-remote-3d-rendering-server-installation/amp