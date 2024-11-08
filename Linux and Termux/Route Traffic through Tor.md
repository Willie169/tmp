## Route Traffic through Tor
To route all traffic in Linux/Termux through Tor, you can use the `torsocks` tool, which is a wrapper that forces any application to use Tor. 
### Step 1: Install Termux packages
```
pkg update && pkg upgrade
pkg install torsocks tor
```
### Step 2: Configure Tor
Edit the Tor configuration file to set up a SOCKS5 proxy on port `9050`, which is the default:
```
nano $PREFIX/etc/tor/torrc
```
Add the following lines if they are not already present (change 9050 to other port if 9050 is used):
```
SOCKSPort 9050
Log notice stdout
```
Set other things like relay in the file too.\
Save and exit the file.
### Step 3: Start Tor
Start the Tor service in Termux:
```
tor
```
This will run Tor and output information on its status.
### Step 4: Use `torsocks` to Route Traffic
You can now route any command through Tor using `torsocks`. For example:
```
torsocks curl https://check.torproject.org
```
This should tell you that your traffic is routed through Tor.
### Optional: Automate Tor Start
You can create a simple script to start Tor automatically when opening Termux:
1. Edit your `.bashrc` or `.zshrc` file:
   ```
   nano ~/.bashrc  # or ~/.zshrc if using zsh
   ```
2. Add the following line to start Tor automatically:
   ```
   tor &
   ```
3. Save and exit the file.
### Optional: Force All Termux Traffic Through Tor
If you want to force all Termux traffic to go through Tor without prefixing `torsocks`, you could modify your environment:
1. Edit your `.bashrc` or `.zshrc` file:
   ```bash
   nano ~/.bashrc  # or ~/.zshrc if using zsh
   ```
2. Add this line to force all commands to go through `torsocks`:
   ```bash
   alias sudo="torsocks sudo"
   alias apt="torsocks apt"
   ```
   Or, use a more general alias to force `torsocks` for every command:
   ```bash
   alias command="torsocks command"
   ```
3. Save and exit the file.
### Optional: Auto start on boot and run in background (not ended by exit)
Install Termux:Boot
```
nano ~/.termux/boot/boot.sh
```
Paste:
```
#!/data/data/com.termux/files/usr/bin/bash
nohup tor &
```