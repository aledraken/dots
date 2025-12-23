#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

pmi=$"sudo pacman -S --needed --noconfirm"

yay=$(pacman -Q | grep yay)
yay="${yay%% *}"

if [[ $yay == "" ]]; then
  echo -e ${RED}YAY is not installed...${NC}
  echo -e ${YELLOW}Installing YAY:${NC}
  mkdir -p $HOME/Packages
  cd $HOME/Packages/
  $pmi git
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si
  echo -e "\n${YELLOW}Did it install properly?${NC}\n"
  read -p "Press anything to continue or CONTROL + C to stop the script"
else
  echo -e "\n${GREEN}YAY is already installed.${NC}\n"
fi
