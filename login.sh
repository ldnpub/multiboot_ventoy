#!/bin/bash
## sdb
## ├─sdb1                                        exfat       ventoy  0983-D32A                                13,7G    49% /media/ldnpub/ventoy
## ├─sdb2                                        vfat        VTOYEFI 7D22-F13A
## └─sdb3                                        crypto_LUKS         f22c8397-d1ad-4c7a-8572-1c025dea549c
##   └─luks-f22c8397-d1ad-4c7a-8572-1c025dea549c ext4        luks    bd3efad6-e18c-42a6-80c3-c20abc8cab3e

setxkbmap fr

# To get the UUID of the created luks partition
# lsblk -f | grep luks_ventoy | awk '{print $4}'
LUKS_PARTITION=`lsblk -f | grep crypto_LUKS | awk '{print $3}'| grep 85`


#PROFILE=rodolphe

if [ $USER != root ]; then
	echo -e "\e[1mCe scrypt necessite les droits ROOT \e[0m"
	exit 1
fi

# cryptsetup luksChangeKey /dev/sdaX
echo -e "\e[1m
***********************************************************
Nous allons configurer l'utilisation de la partition chiffree [LUKS]
\e[0m
"

cryptsetup luksOpen UUID=$LUKS_PARTITION HOME

LUKS_PERSISTENCY=`lsblk -f | grep luks_ventoy | awk '{print $4}'`

#mount /dev/mapper/HOME /home/
mount UUID=$LUKS_PERSISTENCY /home/


echo -e "\e[32m
***********************************************************
*      Vous pouvez vous connecter avec votre compte       *
***********************************************************
\e[0m"
