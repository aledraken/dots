#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

pmi=$"sudo pacman -S --needed --noconfirm"
yi=$"yay -S --needed --noconfirm"
es=$"sudo systemctl enable --now"

echo -e "\nInstalling laptop software\n"

$pmi brightnessctl impala
