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

PACKAGES="$PACKAGES ufw"
SERVICES="$SERVICES ufw"

# DO THE STUFF
$SUDO systemctl daemon-reload
$PMI $PACKAGES
$ES $SERVICES
$EUS $USER_SERVICES

# UFW
$SUDO ufw enable
$SUDO ufw logging off
