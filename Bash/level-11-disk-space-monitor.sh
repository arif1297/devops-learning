#!/bin/bash

disk_usage=$(df -h . | tail -1 | awk '{print $5}')

disk_usage=${disk_usage%\%}

if [ "$disk_usage" -gt 80 ]
then
	echo "disk usage is above threshold"
fi



