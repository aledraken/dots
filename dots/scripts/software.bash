#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

pmi=$"sudo pacman -S --needed --noconfirm"
yi=$"yay -S --needed --noconfirm"

$pmi qbittorrent flatpak
$yi librewolf-bin

flatpak install org.localsend.localsend_app com.github.tchx84.Flatseal

echo -e "\nSymlinking LocalSend firewall rule\n"
sudo ln $HOME/.config/symlinks/ufw/ufw-localsend /etc/ufw/applications.d/ufw-localsend

echo -e "\nAllowing software through firewall\n"
sudo ufw allow LocalSend
sudo ufw allow qBittorrent

echo -e "\nAllowing access to home for LocalSend\n"
flatpak override org.localsend.localsend_app --filesystem=home --user=$USER
