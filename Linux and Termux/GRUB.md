Press ESC on boot to enter GRUB to select which OS to boot

disabe fast boot or secure boot in BIOS for dual boot

In some OS (for dual boot), 

sudo nano /etc/grub.d/30_os_prober

change 

quick_boot="1"

to

quick_boot="0"

# Change default boot OS
sudo nano /etc/default/grub

look for

GRUB_DEFAULT=0

and change (numbers are showed in GRUB, press ESC in boot to see)
in some OS also (when dual boot):

GRUB_DISABLE_OS_PROBER=false

sudo update-grub
sudo reboot




GRUB_TIMEOUT_STYLE=
- hidden: Hide menu without countdown GRUB_HIDDEN_TIMEOUT shown when booted. Show menu when esc, shift is pressed within GRUB_HIDDEN_TIMEOUT.
- menu: Show menu when booted.
- countdown: Hide menu with countdown GRUB_HIDDEN_TIMEOUT shown when booted. Show menu when esc, shift is pressed within GRUB_HIDDEN_TIMEOUT.
GRUB_TIMEOUT=
When GRUB_TIMEOUT_STYLE=menu, the timeout before booting into highlighted option. Some versions may need 0.0 for 0.
GRUB_HIDDEN_TIMEOUT=
When GRUB_TIMEOUT_STYLE=hidden, the timeout before booting into default option. Some versions may need 0.0 for 0.
GRUB_HIDDEN_TIMEOUT_QUIET=
<deprecated, false equivalent to GRUB_TIMEOUT_STYLE=countdown now, hidden equivalent to GRUB_TIMEOUT_STYLE=hidden, may not work correctly in newer versions.>