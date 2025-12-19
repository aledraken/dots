#!/bin/bash

light_theme="Pop"
dark_theme="Pop-dark"

current_theme_raw=$(gsettings get org.gnome.desktop.interface gtk-theme)

current_theme=${current_theme_raw//\'/}

if [[ $current_theme == $light_theme ]]; then
    echo "cur theme is light"
    gsettings set org.gnome.desktop.interface gtk-theme $dark_theme
    dunstify $dark_theme
else
    echo 'cur theme is dark'
    gsettings set org.gnome.desktop.interface gtk-theme $light_theme
    dunstify $light_theme
fi
