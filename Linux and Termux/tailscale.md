# Linux
## Install
```
curl -fsSL https://tailscale.com/install.sh | sh
```
## Log in
```
sudo tailscale up
```
Log in via <https://login.tailscale.com/login>.
## Systemd Enable
```
sudo systemctl enable tailscaled
```
## Manual Start Userspace-Networking
If you don't have systemd
```
sudo tailscaled --tun=userspace-networking &
```
## IP
Your tailscale ip will be
```
tailscale ip
```
You can connect to it via ssh, etc. from another machine with same tailnet (i.e. logged in with same account).
## Subnet Routing
If you want to access devices on your local network through Tailscale, enable subnet routing
```
sudo tailscale up --advertise-routes=192.168.1.0/24
```
# Android
Tailscale for Android can be installed from F-Droid: <https://f-droid.org/packages/com.tailscale.ipn> or Google Play: <https://play.google.com/store/apps/details?id=com.tailscale.ipn>.