#!/bin/bash

# Should make the conf be made on the moment by copying the default one and modifying it

sudo cp zen-linux.conf /boot/loader/entries/zen-linux.conf

sudo pacman -S linux-zen linux-zen-headers
