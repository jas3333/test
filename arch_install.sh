#! /bin/bash
timedatectl set-ntp true

lsblk

echo "Enter disk to setup"
read DISK

read -p "This will erase this disk, are you sure? <y/yes to continue.> " continue

case $continue in
    y|yes)
    sgdisk -Z ${DISK} # Remove everything on disk

    sgdisk -a 2048 -o ${DISK}

    sgdisk -n 1:0:+500M ${DISK}
    sgdisk -n 2:0:0     ${DISK}

    sgdisk -t 1:ef00 ${DISK}
    sgdisk -t 2:8300 ${DISK}

    sgdisk -c 1:"UEFISYS" ${DISK}
    sgdisk -c 2:"ROOT" ${DISK}

    mkfs.vfat -F32 -n "UEFISYS" "${DISK}1"
    mkfs.ext4 -L "ROOT" "${DISK}2"
esac

mount -L ROOT /mnt

pacstrap /mnt base linux linux-firmware vim --noconfirm --needed
genfstab -U /mnt >> /mnt/etc/fstab
mkdir /mnt/test
cd 
cp -r test /mnt/
arch-chroot /mnt 
