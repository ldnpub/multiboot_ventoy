#!/bin/bash

## sdb
## ├─sdb1                                        exfat       ventoy  0983-D32A                                13,7G    49% /media/ldnpub/ventoy
## ├─sdb2                                        vfat        VTOYEFI 7D22-F13A
## └─sdb3                                        crypto_LUKS         f22c8397-d1ad-4c7a-8572-1c025dea549c
##   └─luks-f22c8397-d1ad-4c7a-8572-1c025dea549c ext4        luks    bd3efad6-e18c-42a6-80c3-c20abc8cab3e

echo -e "\e[32m

***********************************************************
*                LUKS_PERSISTENCY Script                  *
*                       ubuntu-fr                         *
***********************************************************
\e[0m"


setxkbmap fr

# To get the UUID of the created luks partition
# lsblk -f | grep luks_ventoy | awk '{print $4}'
LUKS_PARTITION=`lsblk -f | grep crypto_LUKS | awk '{print $3}'| grep 85`


# Root check
if [ $USER != root ]; then
	echo -e "\e[1mCe scrypt necessite les droits ROOT \e[0m"
	exit 1
fi

echo -e "\e[1m
***********************************************************
Nom de votre profil ? \e[0m"
read PROFILE

# cryptsetup luksChangeKey /dev/sdaX
echo -e "\e[1m
***********************************************************
Nous allons changer le mot de passe de la partition chiffree [LUKS]
Le mot de passe par défaut est \e[32mubuntu \e[0m
\e[1mC'est ce mot de passe qui protege vos données en cas de perte de votre cle USB
\e[0m
"
cryptsetup luksChangeKey UUID=$LUKS_PARTITION

#cryptsetup luksOpen /dev/sdb3 HOME

cryptsetup luksOpen UUID=$LUKS_PARTITION HOME

LUKS_PERSISTENCY=`lsblk -f | grep luks_ventoy | awk '{print $4}'`

#mount /dev/mapper/HOME /home/
mount UUID=$LUKS_PERSISTENCY /home/

echo -e "\e[1m***********************************************************
Il va vous etre demande un mot de passe pour vous connecter a votre nouveau compte.
C'est le mot de passe qui vous permet de vous connecter.
Vous pouvez appuyer sur la touche entrée pour le reste des 6 questions qui vous sont posees.
\e[0m"

adduser $PROFILE

# Adding user `test' ...
# Adding new group `test' (1000) ...
# Adding new user `test' (1000) with group `test' ...
# The home directory `/home/test' already exists.  Not copying from `/etc/skel'.
# New password:
# Retype new password:
# passwd: password updated successfully
# Changing the user information for test
# Enter the new value, or press ENTER for the default
# 	Full Name []:
# 	Room Number []:
# 	Work Phone []:
# 	Home Phone []:
# 	Other []:
# Is the information correct? [Y/n]

#useradd -M -r -s /bin/bash $PROFILE
# sed -i "/$PROFILE/d" /etc/shadow

# echo "$PROFILE:\$6\$yJO8dMaA\$5jRSMj22YuX/.vzWhraZ8bfSoFOsEm2Lrd3WG7MUrHl031j5YhLI4oL9KH.keBofrMnyMUtdtjiK.4sK79p0R.:18208:0:99999:7:::" >> /etc/shadow

usermod -aG sudo $PROFILE
#usermod -aG $PROFILE $PROFILE
#chown -R $PROFILE: /home/$PROFILE

# Add new home to FSTAB
# UUID=3acded6f-36fb-4bde-8f28-de4fc1d7ef06 /boot           ext4    defaults        0       2
echo "UUID=$LUKS_PERSISTENCY /home/          ext4    defaults        0       2" >> /etc/fstab


echo -e "\e[32m
***********************************************************
*      Vous pouvez vous deconnecter de cette session      *
*                       a present                         *
*  Vous pouvez vous connecter avec votre nouveau compte   *
***********************************************************
\e[0m"
