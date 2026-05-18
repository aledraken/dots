#!/usr/bin/env bash

set -e

pac=""

pac="$pac qtile xorg-xwayland python-pyxdg python-dbus-fast dunst xdg-utils xdg-desktop-portal-gtk polkit-gnome"

pac="$pac fish starship foot otf-monaspace-nerd noto-fonts ly wl-clipboard"

pac="$pac bat eza git lazygit htop tldr man-db trash-cli yazi"

pac="$pac fwupd udisks2 thermald brightnessctl ufw"

pac="$pac pipewire wireplumber wiremix pipewire-alsa pipewire-jack pipewire-pulse"

case "$(hostnamectl chassis)" in
	"laptop")
		pac="$pac brightnessctl"
		;;
esac

if [ "$(hostnamectl chassis)" != "vm" ]; then
	pac="$pac bluez bluez-utils"
fi

sudo pacman -S --needed $pac

yay -S --needed auto-cpufreq

sudo systemctl enable --now thermald ufw ly@tty2 auto-cpufreq

sudo ufw enable
sudo ufw logging off
