#!/usr/bin/env bash

echo Deleting orphan packages

sudo pacman -Rns $(pacman -Qdtq)

echo Deleting pacman cache

sudo pacman -Scc

echo Emptying trash

trash-empty
