#!/bin/bash

action=$(echo "Log Out|Shut Down|Reboot" | rofi -sep "|" -dmenu -hover-select -me-select-entry '' -me-accept-entry MousePrimary)

if [[ "$action" == "" ]]; then
	exit
fi

confirm=$(echo "Confirm|Cancel" | rofi -sep "|" -dmenu -hover-select -me-select-entry '' -me-accept-entry MousePrimary)

if [[ "$confirm" == "Confirm" ]]; then
	echo $action
fi

if [[ "$action" == "Log Out" ]]; then
	niri msg action quit --skip-confirmation
elif [[ "$action" == "Shut Down" ]]; then
	shutdown -f now
elif [[ "$action" == "Reboot" ]]; then
	reboot
fi
