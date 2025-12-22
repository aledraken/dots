#!/usr/bin/env bash

action=$(echo "Log Out|Shut Down|Reboot" | uwsm-app -- rofi -sep "|" -dmenu -hover-select -me-select-entry '' -me-accept-entry MousePrimary)

if [[ "$action" == "" ]]; then
	exit
fi

confirm=$(echo "Confirm|Cancel" | uwsm-app -- rofi -sep "|" -dmenu -hover-select -me-select-entry '' -me-accept-entry MousePrimary)

if [[ "$confirm" == "Confirm" ]]; then
	echo $action
else
        exit
fi

if [[ "$action" == "Log Out" ]]; then
	uwsm stop
elif [[ "$action" == "Shut Down" ]]; then
	shutdown -f now
elif [[ "$action" == "Reboot" ]]; then
	reboot
fi
