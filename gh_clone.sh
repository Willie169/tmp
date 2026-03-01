#!/usr/bin/env bash

# gh repo clone tmp
# cd tmp
# ./gh_clone.sh
cd ..
test -d Android-Non-Root || gh repo clone Android-Non-Root
test -d AutoJs6-scripts || gh repo clone AutoJs6-scripts
test -d LICENSES || gh repo clone LICENSES
test -d LaTeX-ToolKit || gh repo clone LaTeX-ToolKit
test -d LinuxAndTermuxTips || gh repo clone LinuxAndTermuxTips
test -d Samsung-Android-Debloat-List || gh repo clone Samsung-Android-Debloat-List
test -d Willie169 || gh repo clone Willie169
test -d Willie169.github.io || gh repo clone Willie169.github.io
test -d android-privacy-network-connection-configurations || gh repo clone android-privacy-network-connection-configurations
test -d bashrc || gh repo clone bashrc
test -d btrfs-debian-ubuntu || gh repo clone btrfs-debian-ubuntu
test -d combinedfox || gh repo clone combinedfox
test -d combinedfox-all-in-one-filterlist || gh repo clone combinedfox-all-in-one-filterlist
test -d combinedfox.wiki || gh repo clone combinedfox.wiki
test -d dual-boot-windows-linux-and-recovery || gh repo clone dual-boot-windows-linux-and-recovery
test -d format-converter || gh repo clone format-converter
test -d invizible-pro-dnscrypt-blocklist-generator || gh repo clone invizible-pro-dnscrypt-blocklist-generator
test -d local-ai-setup || gh repo clone local-ai-setup
test -d luanti-misc || gh repo clone luanti-misc
test -d morphe-patch-selections || gh repo clone morphe-patch-selections
test -d my-standard-template-library || gh repo clone my-standard-template-library
test -d nvim-config || gh repo clone nvim-config
test -d physics-patch || gh repo clone physics-patch
test -d switch-firefox-from-snap-to-deb || gh repo clone switch-firefox-from-snap-to-deb
test -d termux-android-sdk-ndk || gh repo clone termux-android-sdk-ndk
test -d termux-sh || gh repo clone termux-sh
test -d ubuntu-setup || gh repo clone ubuntu-setup
test -d unciv-maps || gh repo clone unciv-maps
test -d verilog-modules || gh repo clone verilog-modules
test -d vim-config || gh repo clone vim-config
test -d willie169-ckhs-ntuee-notes || gh repo clone willie169-ckhs-ntuee-notes
test -d willieshen-media || gh repo clone willieshen-media
(cd physics-patch && git checkout dev)
