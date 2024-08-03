#!/bin/bash

file="/etc/pacman.conf"

old_text="#Color"
new_text="Color"

sed -i "s/$old_text/$new_text/" "$file"

old_text="#VerbosePkgLists"
new_text="VerbosePkgLists"

sed -i "s/$old_text/$new_text/" "$file"

old_text="#ParallelDownloads = 5"
new_text="ParallelDownloads = 5"

sed -i "s/$old_text/$new_text/" "$file"

sed -i '/ParallelDownloads = 5/a\ILoveCandy' "$file"