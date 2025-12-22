#!/usr/bin/env bash

light_theme=Nordic-polar
dark_theme=Nordic-darker

light_cursor=macOS
dark_cursor=Nordzy-cursors-white

light_icon=Nordic-darker
dark_icon=Nordic-bluish

current_theme_raw=$(dconf read /org/gnome/desktop/interface/gtk-theme)

current_theme=${current_theme_raw//\'/}

current_theme=$current_theme

if [[ $current_theme == $dark_theme ]]; then
  dconf write /org/gnome/desktop/interface/gtk-theme "\"$light_theme\""
  dconf write /org/gnome/desktop/interface/icon-theme "\"$light_icon\""
  hyprctl setcursor $light_cursor 20
  dunstify $theme
else
  dconf write /org/gnome/desktop/interface/gtk-theme "\"$dark_theme\""
  dconf write /org/gnome/desktop/interface/icon-theme "\"$dark_icon\""
  hyprctl setcursor $dark_cursor 24
  dunstify $theme
fi
