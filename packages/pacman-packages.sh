#!/bin/bash

echo "installing basic stuff"

sudo pacman -S fish xorg-xinit xorg-server ly qtile kitty alsa-utils gufw exfatprogs fuse2

echo "installing utilities"

sudo pacman -S p7zip git qbittorrent tldr htop gvim yazi rofi

echo "installing looks"

sudo pacman -S noto-fonts-emoji
