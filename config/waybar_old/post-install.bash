#!/usr/bin/env bash

GROUP="input"

if id -nG "$USER" | grep -qw "$GROUP"; then
  echo $USER already belongs to $GROUP
else
  echo $USER does not belong to $GROUP
  echo $GROUP group is required for keyboard-state module to work
  echo Adding $USER to $GROUP
  sudo usermod -a -G input $USER
  echo Reboot to apply
fi
