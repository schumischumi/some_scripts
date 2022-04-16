#!/bin/bash

steamfolder="/home/user/steam/steamapps"
mountpoint="$steamfolder/common/Gothic 3/"
source="$steamfolder/common/Gothic 3.src"
savefolder="$steamfolder/compatdata/39500/pfx/drive_c/users/steamuser/My Documents/gothic3"
savbackup=/home/user/saves/gothic3/

# Create ramdisk
sudo mount -t tmpfs -o size=6g tmpfs "$mountpoint"
retVal=$?
if [ $retVal -ne 0 ]; then
    echo "Error while creating tmpfs at $mountpoint"
    exit 1
fi

# copy game to ramdisk
cp -R "$source"/* "$mountpoint"
retVal=$?
if [ $retVal -ne 0 ]; then
    echo "Error while copying $source to $mountpoint"
    exit 1
fi

# move old saves to speed up save scumming
ls -x1  "$savefolder"/G3_World_01_*.g3savcpdat | sort -r | tail -n +2 | xargs -I {} mv -- /{} $savbackup
retVal=$?
if [ $retVal -ne 0 ]; then
    echo "Error while moving $savefolder/G3_World_01_*.g3savcpdat to $savbackup"
    exit 1
fi

ls -x1  "$savefolder"/G3_World_01_*.g3savcp | sort -r | tail -n +2 | xargs -I {} mv -- /{} $savbackup
retVal=$?
if [ $retVal -ne 0 ]; then
    echo "Error while moving $savefolder/G3_World_01_*.g3savcp to $savbackup"
    exit 1
fi


