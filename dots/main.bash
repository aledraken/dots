#!/usr/bin/env bash

# Create the scripts array and find every bash script in the folders
mapfile scripts < <(find . -name "*.bash")
# Remove from the array this script ($0)
scripts=(${scripts[@]/"$0"})

# Work Directory
# Where this script is stored
WD=($PWD)

##########
# COLORS #
##########

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

#############
# SHORTCUTS #
#############

pmi=$"sudo pacman -S --needed --noconfirm"

###########
# WELCOME #
###########

echo -e "\nWelcome to the arch post-install script!\n"
echo "Let's start by enabling the other bash scripts!"
read -p "Continue? (Y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo Goodbye!
  exit
fi

#########################
# CHMOD +x BASH SCRIPTS #
#########################

echo -e "\n${YELLOW}Enabling bash scripts:${NC}\n"

for s in ${scripts[@]}; do
  chmod +x $s

  if [[ -x $s ]]; then
    echo -e $s ${GREEN}was activated succesfully!${NC}
  else
    echo -e $s ${RED}was not activated...${NC}
  fi
done

##############
# AUR helper #
##############

echo
read -p "Install yay? (Y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  ./scripts/install-yay.bash
fi

##########
# CONFIG #
##########

echo
read -p "Copy config files? (Y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  ./scripts/copy-config.bash $WD
fi

############
# HYPRLAND #
############

echo
read -p "Setup Hyprland? (Y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  ./scripts/hyprland.bash
fi

###########
# LAPTOP #
###########

echo
read -p "Setup Laptop software? (Y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  ./scripts/laptop.bash
fi

#########
# POWER #
#########

echo
read -p "Setup Power Management software? (Y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  ./scripts/power-management.bash
fi

###########
# NETWORK #
###########

echo
read -p "Setup Networking (Firewall, DNS, VPN)? (Y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  ./scripts/network.bash
fi

############
# SOFTWARE #
############

echo
read -p "Install software? (Y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  ./scripts/software.bash
fi

###########
# DRIVERS #
###########



