## Shell Script File on Termux
### Create and edit
nano filename.sh
### Paste the following line:
```
!/data/data/com.termux/files/usr/bin/bash
```
Paste commands to be run after that.
### Make it executable
```
chmod +x filename.sh
```
Or for all users
```
chmod a+x filename.sh
```
### Run (parallel session)
```
./filename.sh
```
### Run (current session)
```
source filename.sh
```