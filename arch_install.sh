#! /usr/bin/env bash
timedatectl set-ntp true

lsblk

echo "Enter disk to setup"
read DISK

read -p "This will erase this disk, are you sure?(y to continue otherwise exit)" continue

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
mkdir /mnt/boot
mkdir /mnt/boot/efi
mount -L UEFISYS /mnt/boot 

pacstrap /mnt base linux linux-firmware vim --noconfirm --needed
genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt
ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
hwclock --systohc

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen

locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "arch" >> /etc/hostname
echo "127.0.0.1     localhost" >> /etc/hosts
echo "::1           localhost" >> /etc/hosts
echo "127.0.1.1     arch.localdomain    arch" >> /etc/hosts



