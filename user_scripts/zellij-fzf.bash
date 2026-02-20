#!/usr/bin/env bash


session=$(zellij ls -sn | fzf)
zellij attach $session
