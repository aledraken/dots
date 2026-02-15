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

# Terminal Emulator
PACKAGES="$PACKAGES foot"
USER_SERVICES="$USER_SERVICES foot-server"

# TUI / CLI
PACKAGES="$PACKAGES bat fish starship neovim yazi 7zip htop tldr man-db trash-cli eza zellij git syncthing lazygit wl-clipboard wiremix"

# SECURITY
PACKAGES="$PACKAGES ufw"
SERVICES="$SERVICES ufw"

# DO THE STUFF
$SUDO systemctl daemon-reload
$PMI $PACKAGES
$ES $SERVICES
$EUS $USER_SERVICES
