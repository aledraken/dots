#!/usr/bin/env bash

if [ $USER == "root" ]; then
	echo "Do not run as root"
	exit
fi


DEVICE=$(hostnamectl chassis)
if [ $DEVICE != "laptop" ]; then
  echo "Not a laptop"
  exit
fi

CAUR=$(pacman-conf --repo-list | grep chaotic-aur)
CAURI=true

if [[ $CAUR == "" ]]; then
  echo "Chaotic AUR not installed"
  CAURI=false
fi

if ! $CAURI; then
  exit
fi


SUDO="sudo"
PMI="$SUDO pacman -S --needed --noconfirm"
EUS="$SUDO systemctl --machine=$USER@.host --user enable"
ES="$SUDO systemctl enable --now"
PACKAGES=""
SERVICES=""
USER_SERVICES=""

PACKAGES="$PACKAGES brightnessctl thermald auto-cpufreq"
SERVICES="$SERVICES auto-cpufreq thermald"

# DRIVERS
PACKAGES="$PACKAGES vulkan-intel intel-media-driver vpl-gpu-rt"

# ENV VARS
VAAPI=$(cat /etc/environment | grep LIBVA_DRIVER_NAME)
if [ "$VAAPI" == "" ]; then
  cp /etc/environment /tmp/environment
  echo "export LIBVA_DRIVER_NAME=iHD" >> /tmp/environment
  sudo cp /tmp/environment /etc/environment
fi

ANVDEBUG=$(cat /etc/environment | grep ANV_DEBUG)
if [ "$ANVDEBUG" == "" ]; then
  cp /etc/environment /tmp/environment
  echo "export ANV_DEBUG=video-decode,video-encode" >> /tmp/environment
  sudo cp /tmp/environment /etc/environment
fi

# DO THE STUFF
$SUDO systemctl daemon-reload
$PMI $PACKAGES
$ES $SERVICES
$EUS $USER_SERVICES

# UFW
$SUDO ufw enable
$SUDO ufw logging off
