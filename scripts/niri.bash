#!/usr/bin/env bash

if [ $USER == "root" ]; then
	echo "Do not run as root"
	exit
fi

DEVICE=$(hostnamectl chassis)
SUDO="sudo"
PMI="$SUDO pacman -S --needed --noconfirm"
EUS="$SUDO systemctl --machine=$USER@.host --user enable"
ES="$SUDO systemctl enable --now"
PACKAGES=""
SERVICES=""
USER_SERVICES=""

# DESKTOP ENVIRONMENT
PACKAGES="$PACKAGES uwsm ly xdg-desktop-portal-gtk niri foot fuzzel waybar dunst libnotify cliphist"
SERVICES="$SERVICES ly@tty2"
USER_SERVICES="$USER_SERVICES waybar foot-server cliphist"
echo -e "[Unit]
Description=Clipboard history "manager" for Wayland
Documentation=https://github.com/sentriz/cliphist
PartOf=graphical-session.target
After=graphical-session.target
Requisite=graphical-session.target

[Service]
ExecStart=wl-paste --watch cliphist store
ExecReload=pkill wl-paste && wl-paste --watch cliphist store
Restart=on-failure

[Install]
WantedBy=graphical-session.target" > /tmp/cliphist.service
$SUDO cp /tmp/cliphist.service /usr/lib/systemd/user/

# TERMINAL
PACKAGES="$PACKAGES bat fish starship neovim yazi 7zip htop tldr man-db trash-cli eza zellij git syncthing lazygit"

# LAPTOP PACKAGES
if [ $DEVICE == "laptop" ]; then
	PACKAGES="$PACKAGES brightnessctl impala thermald auto-cpufreq"
	SERVICES="$SERVICES auto-cpufreq"
fi

# SECURITY
PACKAGES="$PACKAGES ufw"
SERVICES="$SERVICES ufw"

# BLUETOOTH
if ! [ $DEVICE == "vm" ]; then
  echo "Not in a vm #TODO bluetooth"
fi

# AUDIO
PACKAGES="$PACKAGES wireplumber"
USER_SERVICES="$USER_SERVICES pipewire"

# THEMING
PACKAGES="$PACKAGES otf-monaspace-nerd"

# DO THE STUFF
$SUDO systemctl daemon-reload
$PMI $PACKAGES
$ES $SERVICES
$EUS $USER_SERVICES

# UFW
$SUDO ufw enable
$SUDO ufw logging off

# WAYLAND SESSION
echo -e "[Desktop Entry]
Name=Niri (UWSM)
Comment=A scrollable-tiling Wayland compositor
Exec=uwsm start -- niri.desktop
TryExec=uwsm
Type=Application
DesktopNames=niri" > /tmp/niri-uwsm.desktop
$SUDO cp /tmp/niri-uwsm.desktop /usr/share/wayland-sessions/
