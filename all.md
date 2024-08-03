[tools]
tldr
fish
vim
htop
p7zip

[dependencies]
xorg-xinit
xorg-server

[environment]
ly
qtile
kitty
yazi
rofi
alsa-utils

picom

[others]
gufw
git

[aur]
paru

---

[services]

ufw

ly

---

[ly]
/etc/ly/config.ini
clock = %a %b %D
bigclock = true

[pacman]
/etc/pacman.conf
Color
VerbosePkgLists
ParallelDownloads = 5
ILoveCandy

[gufw]
/usr/bin/gufw
pkexec /usr/bin/gufw-pkexec ...

[fish]
set -U fish_greeting ""

vim .config/fish/config.fish
if ...
	fastfetch
end

---

[notes]

Might be better to have instead of alt + l to change keyboard layout, to remap the caps lock to nothing and bind the shortcut to just that,
and then I could remap num block to if pressed num lock, held caps lock

[to-do]

Moving the mouse with the caps lock and numpad in linux?

Bluetooth

Hotspot

