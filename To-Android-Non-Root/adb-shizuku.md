### ADB, Shizuku, SystemUI Tuner, and aShell: Use Local ADB of Android Device on Terminals Such as Termux without Another Device with Shizuku, Leave Developer Options off When Doing So with SystemUI Tuner, and Use ADB with Features like Autocomplete Suggestion with aShell

## Software Introduction

### Android Debug Bridge (ADB)

The Android Debug Bridge (ADB) is a programming tool used for the debugging of Android-based devices. The daemon on the Android device connects with the server on the host PC over USB or TCP, which connects to the client that is used by the end-user over TCP. Made available as open-source software under the Apache License by Google, its features include a shell and the possibility to make backups. The ADB software is available for many devices such as Windows, Linux and macOS. It has been misused by botnets and other malware, for which mitigations were developed such as RSA authentication and device whitelisting.

### Shizuku

Shizuku is an open-source app for serving multiple apps that require root/adb. If your "root required app" only needs adb permission, you can easily expand the audience by using Shizuku. Also, Shizuku is significantly faster than root shell.

The [thedjchi/Shizuku](https://github.com/thedjchi/Shizuku) fork is recommended since it adds many good features on top of the original [RikkaApps/Shizuku](https://github.com/RikkaApps/Shizuku).

The original repo has an [official site](https://shizuku.rikka.app) that offers some instructions.

### Termux

Termux is an Android terminal application and Linux environment. Termux combines powerful terminal emulation with an extensive Linux package collection. Some of the commands available in Linux are available in Termux too, such as `cp`, `mv`, `ls`, `mkdir`, `apt`, and `apt-get`.

Termux (`com.termux`) can be installed from [F-Droid](https://f-droid.org/packages/com.termux).

**WARNING**: If you installed termux from Google Play or a very old version, then you will receive package command errors. Google Play builds are deprecated and no longer supported. It is highly recommended that you update to termux-app v0.118.0 or higher as soon as possible for various bug fixes, including a critical world-readable vulnerability reported at <https://termux.github.io/general/2022/02/15/termux-apps-vulnerability-disclosures.html>. It is recommended that you shift to F-Droid or GitHub releases.

Refer to [**Android-Non-Root**](https://github.com/Willie169/Android-Non-Root) for more information.

## Enable ADB Debugging

## Install ADB Server

This section list methods to install ADB server. Note that ADB server is not required for [Shizuku with rish](#shizuku-with-rish).

### sdkmanager

Refer to <https://developer.android.com/tools/sdkmanager> to install sdkmanager, put where it locates in `$PATH`, and execute
```bash
sdkmanager "platform-tools"
```
Alternatively, for Linux x86\_64, the following script may work for you.
```bash
cd ~ || exit
wget --tries=100 --retry-connrefused --waitretry=5 -O studio.html https://developer.android.com/studio
export CMDLINETOOLS="$(awk '/<table class="download">/ { count++ }
count >= 2 {
  if (match($0, /commandlinetools-linux-.*zip/)) {
    print substr($0, RSTART, RLENGTH)
    exit
  }
}' studio.html)"
rm studio.html*
wget --tries=100 --retry-connrefused --waitretry=5 "https://dl.google.com/android/repository/${CMDLINETOOLS}"
unzip "$CMDLINETOOLS"
mkdir -p ~/Android/Sdk/cmdline-tools/latest
mv cmdline-tools/* ~/Android/Sdk/cmdline-tools/latest
rm -r cmdline-tools
rm "$CMDLINETOOLS"*
cd ~/Android/Sdk/cmdline-tools/latest/bin || exit
echo y | ./sdkmanager "platform-tools"
```

### Binary

1. Download latest release asset matching your machine from [scrcpy](https://github.com/Genymobile/scrcpy/releases).
2. Extract it. `.zip` can be extracted with `unzip`. `.tar.gz` can be extracted with `tar -xzf`.
3. Move `adb` in the extracted directory to some where in your `$PATH`, e.g., `~/.local/bin`.

Alternatively, for Linux x86\_64, the following script may work for you,
```bash
. <(curl -fsSL 'https://raw.githubusercontent.com/Willie169/bashrc/refs/heads/main/bashrc.d/30-shared-functions.sh')
gh_release -w --wget_option '--tries=100 --retry-connrefused --waitretry=5' Genymobile/scrcpy 'scrcpy-linux-x86_64-*.tar.gz'
tar -xzf scrcpy-linux-x86_64-*.tar.gz
mv scrcpy-linux-x86_64-*/adb ~/.local/bin/
mv scrcpy-linux-x86_64-*/scrcpy ~/.local/bin/
rm -r scrcpy-linux-x86_64-*
```

### Termux

```bash
pkg install android-tools -y
```

## Connect to ADB

This section list methods to connect to ADB of an Android device (called client).

### Another Device over USB

Prerequisites:
- Another device with ADB server installed (called host).
- USB cable connecting host and client.

### Shizuku with rish






### Connect Shizuku to Wireless ADB

1. Grant Shizuku notification permission.
2. Tap `Pairing` in `Start via Wireless debugging` block in Shizuku.
3. Connect to a WiFi you trust. You don’t need to log in to the WiFi though. You just need to let your phone think that you’re connected to WiFi.
4. In phone’s `Settings` or something similar, go to `About Phone` \> `Software Information` or something similar, and tap the `Version Number` seven times to enable `Developer Options`. Some phones may have different methods to enable `Developer Options`.
5. In the `Developer Options`, enable `Wireless ADB` and tap `Pair with a pairing code`.
6. Input the pairing code in the notification of Shizuku.
7. In the `Developer Options`, togle on `Disable adb authorization timeout` if you don’t want to do all the above again every few times using Shizuku. If the connection is disconnected due to whatever reason, follow [Reconnect Shizuku in Case it Stops with SystemUI Tuner](#reconnect-shizuku-in-case-it-stops-with-systemui-tuner) to reconnect if you’re using SystemUI Tuner, or follow above guide again to reconnect.
8. Back to Shizuku and tap `Start` in `Start via Wireless debugging` block. You all see Shizuku is running on the top of the app interface of Shizuku.

### Use Shizuku in a Terminal Application for the First Time

1. Tap `Use Shizuku in terminal applications` in Shizuku and export files `rish` and `rish_shizuku.dex` to somewhere on your phone.
2. Use a text editor to replace `PKG` in `rish` with the package name of your terminal application. Take Termux for example, Termux’s package name is `com.termux`. Run `termux-setup-storage` and tap `Allow to grant Termux storage permission`.
3. Open your terminal application and move the exported files to somewhere it can access (usually with `mv old_location new_location`). The root directory of the main storage of Android is usually `/storage/emulated/0`. One recommended terminal application for Android is Termux. My guide for it is available in [Termux: A Powerful Terminal Emulation with an Extensive Linux Package Collection](#termux-a-powerful-terminal-emulation-with-an-extensive-linux-package-collection).
4. Go to the directory you moved the exported files to with `cd directory` (assumed `~/shizuku` below) and run `sh rish`.
5. `~ $` should become `<device>:/ $` (such as `e2q:/ $`) if `sh rish` succeeded. Write ADB commands here. Note that there is no need to use `adb` or `adb shell` prefixes before commands and that `devices` command gets `/system/bin/sh: devices: inaccessible or not found`.
6. You can turn WiFi off after ADB is connected. The notification of Shizuku may say Paring failed after that, but you can check Shizuku app to check whether there’s a block that reads `Shizuku is running` on the top.
7. Optionally, create a `.sh` file (`nano ~/shizuku.sh` for example), paste `cd shizuku && sh rish`, save it, and make it executable with `chmod +x shizuku.sh` so that you can run this shortcut to start Shizuku on your terminal afterward.

### Install SystemUI Tuner

SystemUI Tuner can be installed from [Google Play](https://play.google.com/store/apps/details?id=com.zacharee1.systemuituner) (pub: Zachary Wander).

### To Leave Developer Options off When Using Shizuku to Connect to ADB with SystemUI Tuner

Some apps (such as many financial apps) may require `Developer Options` to be off when using them. This section is the guide about how to turn `Developer Options` off while still using ADB Shell with Shizuku.

1. Run `adb shell` command `pm grant com.zacharee1.systemuituner android.permission.WRITE_SECURE_SETTINGS` (you can do it with Shizuku and a terminal such as Termux or aShell).
2. Connect to a WiFi. You don’t need to log in or have real WiFi access, just make your phone believes you are connected to WiFi.
3. Turn off `Developer Options` if it’s on. The toggle switch is usually on the top of `Developer Options`.
4. In SystemUI Tuner, go to `Developer` and turn on `Enable ADB` and `Enable Wireless ADB`.
5. In SystemUI Tuner, go to `Persistent Options` and select `Enable ADB`.
6. Press `Start` on Shizuku.
7. Turn off WiFi. `Enable Wireless ADB` will be turned off automatically by system settings. You can check that in `SystemUI Tuner`.

### Reconnect Shizuku in Case it Stops with SystemUI Tuner

1. Connect to a WiFi. You don’t need to log in or have real WiFi access, just make your phone believes you are connected to WiFi.
2. Turn off `Developer Options` if it’s on. The toggle switch is usually on the top of `Developer Options`.
3. In SystemUI Tuner, go to `Developer` and turn on `Enable Wireless ADB`.
4. Press `Start` on Shizuku.
5. Turn off WiFi. `Enable Wireless ADB` will be turned off automatically by system settings. You can check that in SystemUI Tuner.

### Other SystemUI Tuner Usage

SystemUI Tuner exposes some hidden options in Android. You can set them, add them to `Persistent Options` to keep them on, etc. Different manufacturers may remove or change these options, which SystemUI Tuner may not work around.

You may need to run the following `adb shell` command (you can do it with Shizuku and a terminal such as Termux or aShell) in order to change the settings:

```
pm grant com.zacharee1.systemuituner android.permission.WRITE_SECURE_SETTINGS
pm grant com.zacharee1.systemuituner android.permission.PACKAGE_USAGE_STATS
pm grant com.zacharee1.systemuituner android.permission.DUMP
```

### aShell

#### Install aShell

aShell can be installed from [F-Droid](https://f-droid.org/packages/in.sunilpaulmathew.ashell).

#### Introduction of aShell

* An elegantly designed user interface.
* Included a bundle of examples about common adb commands.
* Handles continuously running commands, such as logcat, top, etc.
* Search for specific text from the last command output.
* Option to save last command output as a text file.
* Bookmark frequently using commands.
* Dark/light theme.
* Auto complete.

#### Usage of aShell

1. Give aShell the permission `moe.shizuku.manager.permission.API_V23`.
2. Connect to ADB.
3. Use aShell.

### Further Readings and References about ADB and Shizuku

* <https://developer.android.com/tools/adb>.
* <https://android.googlesource.com/platform/packages/modules/adb>.
* <https://shizuku.rikka.app>.

