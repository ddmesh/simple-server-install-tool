#!/bin/bash
# License: GPL-3.0-or-later
# Copyright (c) Stephan Enderlein 2006-2021

VSERVER_FILES_DIR=./files
#RESCUE_MOUNT_DIR='/mnt'

#vergleiche alle files gegen die files im system

cd $VSERVER_FILES_DIR

echo '[32m----- files not in main system (but in vserver_dir) ----[0m'
for i in $(find .)
do
	tmp="${i:1}"	# substring: remove leading dot
	file="$RESCUE_MOUNT_DIR"$tmp

 	test -z "$file" && continue
	test -e "$file" || echo "[31mmissing: ./files$file[0m"
done 

echo '[32m----- diff: server <-> vserver_dir -----[0m'
for i in $(find .)
do
	#dont diff directories, only files that are present on
	#server and vserver_dir

	if [ ! -d $i -a -e $i -a -e /$i ]; then
 		diff -q $RESCUE_MOUNT_DIR/$i $i >/dev/null || {
			if [ "$1" = "meld" ]; then
				echo "[31mdifferent: $i -> starting meld[0m"
				meld $RESCUE_MOUNT_DIR/$i $i
			else
				echo "[31mdifferent: $i [0m"
			fi
		}
	fi
done 

if [ "$1" != "meld" ]; then
	echo "usage: $0 [meld]"
fi

