#!/bin/bash

directory="."
if [ ! -d "$directory" ]
then
	echo "Directory not found"
	exit 1
fi

log_file="$HOME/changes.log"

inotifywait -m -e create -e modify -e delete "$directory" | while read -r event
do
	timestamp=$(date)
	echo "$timestamp - $event" >> "$log_file"
done

