#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

pmi=$"sudo pacman -S --needed --noconfirm"
yi=$"yay -S --needed --noconfirm"
eus=$"sudo systemctl --machine=$USER@.host --user enable --now"

echo -e "\nInstalling Hypr ecosystem\n"
$pmi uwsm libnewt
$pmi hyprland hyprpolkitagent xdg-desktop-portal-hyprland hyprlock hypridle


echo -e "\nSymlinking .bashrc (boot menu)\n"
mv $HOME/.bashrc $HOME/.bashrc.old
ln $HOME/.config/symlinks/home/.bashrc $HOME/.bashrc


echo -e "\nInstalling Fonts\n"
$pmi ttf-jetbrains-mono-nerd


echo -e "\nInstalling Terminal and cli/tui software\n"
$pmi foot fish starship neovim 7zip htop yazi bat eza tldr wl-clipboard trash-cli


echo -e "\nInstalling gui stuff\n"
$pmi waybar rofi dunst libnotify


echo -e "\nInstalling theming stuff\n"
$pmi swww matugen

$pmi papirus_icon_theme adw-gtk-theme
$yi apple_cursor

echo -e "\nSymlinking swww-daemon"
sudo ln $HOME/.config/symlinks/systemd-user/swww-daemon.service /usr/lib/systemd/user/swww-daemon.service


echo -e "\nEnabling services\n"
echo "Reloading systemctl"
sudo systemctl daemon-reload

$eus hyprpolkitagent
$eus hypridle
$eus waybar
$eus swww-daemon
