#!/bin/bash

file="/etc/ly/config.ini"

old_text="clock = null"
new_text="clock = %a %b %D"

sed -i "s/$old_text/$new_text/" "$file"

old_text="bigclock = false"
new_text="bigclock = true"

sed -i "s/$old_text/$new_text/" "$file"