## Termux VNC
### Install
```
pkg install tigervnc
```
### Start
```
vncserver -localhost
```
At first time, you will be prompted for setting up passwords:
```
You will require a password to access your desktops.

Password:
Verify:
Would you like to enter a view-only password (y/n)? n
```
Note that passwords are not visible when you are typing them and maximal password length is 8 characters.\
If everything is okay, you will see this message:
```
New 'localhost:1 ()' desktop is localhost:1

Creating default startup script /data/data/com.termux/files/home/.vnc/xstartup
Creating default config /data/data/com.termux/files/home/.vnc/config
Starting applications specified in /data/data/com.termux/files/home/.vnc/xstartup
Log file is /data/data/com.termux/files/home/.vnc/localhost:1.log
It means that X (vnc) server is available on display 'localhost:1'.
```
Finally, to make programs do graphical output to the display 'localhost:1', set environment variable like shown here (yes, without specifying 'localhost'):
```
export DISPLAY=":1"
```
You may even put this variable to your bashrc or profile so you don't have to always set it manually unless display address will be changed.