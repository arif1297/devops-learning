#!/bin/bash

mkdir -p Arena_Boss
cd Arena_Boss
touch file1.txt file2.txt file3.txt file4.txt file5.txt


for file in file1.txt file2.txt file3.txt file4.txt file5.txt
do

	lines=$((RANDOM % 11 + 10))


	for (( i=1; i<=$lines; i++ ))
	do
		echo "line $i" >> "$file"
	
	done

done

ls -Sr *.txt


if grep -q  "Victory" *.txt
then 
	mkdir -p  Victory_Archive
	
	for file in $(grep -l "Victory" *.txt )
	do
		mv "$file" Victory_Archive/
	done
fi

