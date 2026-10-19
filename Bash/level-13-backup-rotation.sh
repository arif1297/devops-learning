#!/bin/bash

mkdir -p /home/arif/Arena_Backup

timestamp=$(date +"%Y-%m-%d_%H-%M-%S")

backup_name="Arena_$timestamp"

cp -r . /home/arif/Arena_Backup/"$backup_name"

backup_count=$(ls /home/arif/Arena_Backup | wc -l)

if [ "$backup_count" -gt 5 ]
then
	oldest_backup=$(ls /home/arif/Arena_Backup | head -1)
	echo "Deleting oldest backup : "$oldest_backup""
	rm -r "/home/arif/Arena_Backup/$oldest_backup"
fi

