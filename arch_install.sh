#! /usr/bin/env bash
timedatectl set-ntp true

lsblk

echo "Enter disk to setup"
read DISK

sgdisk -Z ${DISK} # Remove everything on disk

sgdisk -a 2048 -o ${DISK}

sgdisk -n 1:0:+500M ${DISK}
sgdisk -n 2:0:0     ${DISK}

sgdisk -t 1:ef00 ${DISK}
sgdisk -t 2:8300 ${DISK}

sgdisk -c 1:"UEFISYS" ${DISK}
sgdisk -c 2:"ROOT" ${DISK}

mkfs.vfat -F32 "UEFISYS" "${DISK}1"
mkfs.ext4 "ROOT" "${DISK}2"
