#!/usr/bin/env bash

/usr/sbin/swaync &
gsettings set org.gnome.desktop.interface cursor-size 38 & # fix swaync huge cursor
#/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
