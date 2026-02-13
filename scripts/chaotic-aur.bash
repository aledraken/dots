#!/usr/bin/env bash

CAUR=$(pacman-conf --repo-list | grep chaotic-aur)

if ! [[ $CAUR == "" ]]; then
  echo "Chaotic already installed"
  exit
fi

SUDO="sudo"
KEY="3056513887B78AEB"
KEYSERVER="keyserver.ubuntu.com"
KEYRING="https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst"
MIRRORLIST="https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst"

$SUDO pacman-key --recv-key $KEY --keyserver $KEYSERVER
$SUDO pacman-key --lsign-key $KEY

$SUDO pacman -U $KEYRING
$SUDO pacman -U $MIRRORLIST

cp /etc/pacman.conf /tmp/pacman.conf
echo -e "
[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist" >> /tmp/pacman.conf
$SUDO cp /tmp/pacman.conf /etc/pacman.conf
$SUDO pacman -Syu
