#!/bin/bash

echo "choose an option:"

echo "1. check disk space"
echo "2. show system uptime"
echo "3. list users"


read choice
case $choice in
	1) df -h ;;
	2) uptime ;;
	3) who ;;
	*) echo "invalid option" ;;
esac


