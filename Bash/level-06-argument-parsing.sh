#!/bin/bash

if [ -z $1 ]
then 
	echo "No file provided"
else
	wc -l $1 
fi
