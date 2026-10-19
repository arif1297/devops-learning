#!/bin/bash

echo "choose an option:"

echo "1. check disk space"
echo "2. show system uptime"
echo "3. backup Arena directory"
echo "4. display settings"

read choice
case $choice in
	1) df -h ;;
	2) uptime ;;
	3) mkdir -p /home/arif/Arena_Backup

	timestamp=$(date +"%Y-%m-%d_%H-%M-%S")

	backup_name="Arena_$timestamp"

	cp -r . /home/arif/Arena_Backup/"$backup_name"

	backup_count=$(ls /home/arif/Arena_Backup | wc -l)

	if [ "$backup_count" -gt 3 ]
	then
    		oldest_backup=$(ls /home/arif/Arena_Backup | head -1)
    		echo "Deleting oldest backup: $oldest_backup"
    		rm -r "/home/arif/Arena_Backup/$oldest_backup"
	fi ;;

	4) while IFS='=' read key value
	do
   		 echo "Key: $key, Value: $value"
	done < config.txt ;;
      	
	*) echo "invalid option"

esac	
