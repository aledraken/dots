#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

pmi=$"sudo pacman -S --needed --noconfirm"
yi=$"yay -S --needed --noconfirm"
es=$"sudo systemctl enable --now"

$pmi ufw
$es ufw
sudo ufw enable
sudo ufw logging off

echo "\nSetting up dns\n"

$pmi dnscrypt-proxy
$es dnscrypt-proxy

echo -e "\nSymlinking config files\n"
sudo ln --force $HOME/.config/symlinks/iwd/main.conf /etc/iwd/main.conf
sudo ln --force $HOME/.config/symlinks/iwd/resolv.conf /etc/resolv.conf
