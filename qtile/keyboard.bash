#!/bin/bash

current_layout() {
		local layout=$(setxkbmap -query | grep layout | cut -d ':' -f 2)
	echo "$layout"
}

layout=$(current_layout)

if [[ "$layout" != "     us" ]];
then
	setxkbmap us
else
	setxkbmap it
fi
