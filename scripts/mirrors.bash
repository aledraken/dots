#!/usr/bin/env bash

SUDO="sudo"
CAT="bat"

$SUDO reflector --latest 5 --sort rate --save /etc/pacman.d/mirrorlist

$CAT /etc/pacman.d/mirrorlist
