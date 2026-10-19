#!/bin/bash

mkdir Battlefield
cd Battlefield
touch knight.txt sorcerer.txt rogue.txt

if [ -f knight.txt ]
then
	mkdir Archive
	mv knight.txt Archive
fi

ls
cd Archive
ls
