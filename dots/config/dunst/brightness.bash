#!/usr/bin/env bash

max=$(brightnessctl m)
current=$(brightnessctl g)
current_percentage=$(($current * 100 / $max))

dunstify "Current brightness: $current_percentage%" -h int:value$current_percentage --replace 4410 --timeout 1000
