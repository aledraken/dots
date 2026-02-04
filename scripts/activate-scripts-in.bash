#!/usr/bin/env bash

DIR=$1

if ! [ -d "$DIR" ]; then
	echo "$DIR doesn't exist"
	exit
fi

mapfile scripts < <(find $DIR -name "*.bash")

for s in ${scripts[@]}; do
	chmod +x $s

	if [[ -x $s ]]; then
		echo -e "$s\nwas activated"
	else
		echo -e "$s\nWAS NOT ACTIVATED"
	fi
done
