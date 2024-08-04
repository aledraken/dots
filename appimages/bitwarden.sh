#!/bin/bash

mkdir -p ~/.local/share/applications

echo "Check/Create applications folder"

cp bitwarden.desktop ~/.local/share/applications/bitwarden.desktop

echo "Copied desktop file"

python -m webbrowser -t "https://vault.bitwarden.com/download/?app=desktop&platform=linux"

echo "Started appimage download"

mkdir -p ~/AppImages

echo "Check/Create AppImages dir"

read -p "Has download finished? (type anything): " answer
case "$answer" in 
    *)
	appimage=$(find ~/Downloads/ -type f -name "*Bitwarden*")
	mv "$appimage" ~/AppImages/Bitwarden.AppImage
	chmod +x ~/AppImages/Bitwarden.AppImage
	echo "Copied appimage"
	;;
esac
