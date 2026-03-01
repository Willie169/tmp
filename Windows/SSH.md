# SSH
## Client
Built in in cmd.
## Server
### Installation
Run cmd as administrator:
```
powershell -Command "Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0"
```
### Server
```
net start sshd
```
```
net stop sshd
```
### Enable on boot
```
sc config sshd start= auto
```
### IP
```
ipconfig
```
### Config
Run cmd as administrator:
```
notepad C:\ProgramData\ssh\sshd_config
```
