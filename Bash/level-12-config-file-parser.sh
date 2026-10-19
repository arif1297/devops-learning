#!/bin/bash

while IFS='=' read key value
do
	echo "Key : $key, Value: $value"
done < config.txt


