#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

pmi=$"sudo pacman -S --needed --noconfirm"

if ! test -f /usr/local/bin/am; then
  echo -e ${RED}AM is not installed...${NC}
  echo -e ${YELLOW}Installing AM:${NC}
  mkdir -p $HOME/Packages
  cd $HOME/Packages/
  $pmi git wget
  git clone https://github.com/ivan-hc/AM.git
  cd AM
  chmod a+x INSTALL
  sudo ./INSTALL
  echo -e "\n${YELLOW}Did it install properly?${NC}\n"
  read -p "Press anything to continue or CONTROL + C to stop the script"
else
  echo -e "\n${GREEN}AM is already installed.${NC}\n"
fi
