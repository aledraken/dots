#!/usr/bin/env bash

session=$(zellij ls -sn | fzf)

if [ "$session" == "" ]; then
  exit
fi

footclient zellij attach $session & disown
