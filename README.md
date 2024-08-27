# dots

[gaming]

Need to create another script to install gaming stuff

steam lutris

Lutris drivers and dependencies:

https://github.com/lutris/docs/blob/master/Performance-Tweaks.md

https://github.com/lutris/docs/blob/master/InstallingDrivers.md

https://github.com/lutris/docs/blob/master/WineDependencies.md

[work?]

krita

godot

[tools]

thunderbird

feh

mpv

xdotool

nm-connection-editor

parted

libreoffice-fresh

xf86-input-wacom

gamemode

gamescope

mangohud

noto-fonts-cjk

[aur]

p7zip-gui

powerkit

android-studio

---

dnsmasq package needed maybe if it doesn't work
https://wiki.archlinux.org/title/NetworkManager#DNS_management

linux-wifi-hotspot

if ufw blocks connection

sudo ufw allow in on wlp3s0

sudo ufw route allow out on enp2s0

sudo ufw status numbered

[ 1] Anywhere on wlp3s0         ALLOW IN    Anywhere                  
[ 2] Anywhere on enp2s0         ALLOW FWD   Anywhere                   (out)
[ 3] Anywhere (v6) on wlp3s0    ALLOW IN    Anywhere (v6)             
[ 4] Anywhere (v6) on enp2s0    ALLOW FWD   Anywhere (v6)              (out)

---

Not really useful but might add a script to do this

[fish]

vim .config/fish/config.fish
if ...
	fastfetch
end

---

[to-do]

Enable/disable touch of wacom tablet with shortcut in qtile config

Media control in center of bar (should be easy)

Might be better to have instead of alt + l to change keyboard layout, to remap the caps lock to nothing and bind the shortcut to just that,
and then I could remap num block to if pressed num lock, held caps lock

Bluetooth

Hotspot

