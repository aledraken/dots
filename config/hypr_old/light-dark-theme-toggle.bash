#!/usr/bin/env bash

# For gtk themes
# /usr/share/themes/
# For icons and cursors
# /usr/share/icons/

light_theme=adw-gtk3
dark_theme=adw-gtk3-dark

light_cursor=macOS
dark_cursor=macOS-White

light_icon=Papirus-Light
dark_icon=Papirus-Dark

current_theme_raw=$(dconf read /org/gnome/desktop/interface/gtk-theme)

current_theme=${current_theme_raw//\'/}

current_theme=$current_theme

if [[ $current_theme == $dark_theme ]]; then
  dconf write /org/gnome/desktop/interface/gtk-theme "\"$light_theme\""
  dconf write /org/gnome/desktop/interface/icon-theme "\"$light_icon\""
  hyprctl setcursor $light_cursor 23
  dunstify $theme
else
  dconf write /org/gnome/desktop/interface/gtk-theme "\"$dark_theme\""
  dconf write /org/gnome/desktop/interface/icon-theme "\"$dark_icon\""
  hyprctl setcursor $dark_cursor 23
  dunstify $theme
fi
