#!/bin/bash
## sdb
## ├─sdb1                                        exfat       ventoy  0983-D32A                                13,7G    49% /media/ldnpub/ventoy
## ├─sdb2                                        vfat        VTOYEFI 7D22-F13A
## └─sdb3                                        crypto_LUKS         f22c8397-d1ad-4c7a-8572-1c025dea549c
##   └─luks-f22c8397-d1ad-4c7a-8572-1c025dea549c ext4        luks    bd3efad6-e18c-42a6-80c3-c20abc8cab3e

setxkbmap fr fr

# To get the UUID of the created luks partition
# lsblk -f | grep luks_ventoy | awk '{print $4}'
LUKS_PARTITION=`lsblk -f | grep luks_ventoy | awk '{print $4}'`

#PROFILE=rodolphe

if [ $USER != root ]; then
	echo "Please run a root"
	exit 1
fi

echo "Nom de votre profil ? "
read PROFILE

# Create /etc/shadow Password: openssl passwd -1


# mkdir /media/scripts
# umount UUID=7e337cff-f7b2-4d86-8732-59e0dcbd7f10
# mount UUID=7e337cff-f7b2-4d86-8732-59e0dcbd7f10 /media/scripts

#cryptsetup luksOpen /dev/sdb3 HOME
cryptsetup luksOpen UUID=$LUKS_PARTITION HOME
#mount /dev/mapper/HOME /home/
mount UUID=$LUKS_PARTITION /home/

echo "############################"

useradd -M -r -s /bin/bash $PROFILE
sed -i "/$PROFILE/d" /etc/shadow

echo "$PROFILE:\$6\$yJO8dMaA\$5jRSMj22YuX/.vzWhraZ8bfSoFOsEm2Lrd3WG7MUrHl031j5YhLI4oL9KH.keBofrMnyMUtdtjiK.4sK79p0R.:18208:0:99999:7:::" >> /etc/shadow

usermod -aG sudo $PROFILE
usermod -aG $PROFILE $PROFILE
chown -R $PROFILE: /home/$PROFILE

echo "
#######################################
#  You may now log into your account  #
#######################################
"
