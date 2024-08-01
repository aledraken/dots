#!/bin/bash

cd ~/Packages
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si