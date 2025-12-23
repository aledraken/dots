##!/usr/bin/env bash

current_percentage=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2}' | awk '{print $1 * 100}')

muted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $3}')

if [[ "$muted" == "[MUTED]" ]]; then
    dunstify "Current volume: MUTED" -h int:value:$current_percentage --replace 4410 --timeout 1000
else
    	dunstify "Current volume: $current_percentage%" -h int:value:$current_percentage --replace 4410 --timeout 1000
fi
