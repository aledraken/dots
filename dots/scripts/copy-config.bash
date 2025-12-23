#!/usr/bin/env bash

WD=$1

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo -e "\n${YELLOW}Backing up old .config${NC}\n"

cp -r $HOME/.config/ $HOME/.config.old/

echo -e "\n${GREEN}Copied .config to .config.old${NC}\n"

cp -r $1/config/. $HOME/.config/

echo -e "\n${GREEN}Copied config to .config${NC}\n"
