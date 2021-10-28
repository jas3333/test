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
mkdir /boot/efi
mount -L UEFISYS /boot/efi 

pacstrap /mnt base linux linux-firmware vim --noconfirm --needed
genfstab -U /mnt >> /mnt/etc/fstab
mkdir /mnt/root/test
cp -R /test /mnt/root/test
arch-chroot /mnt /bin/bash << EOF

ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "arch" >> /etc/hostname
echo "127.0.0.1     localhost" >> /etc/hosts
echo "::1           localhost" >> /etc/hosts
echo "127.0.1.1     arch.localdomain    arch" >> /etc/hosts
pacman -S grub efibootmgr networkmanager network-manager-applet wireless_tools openssh base-devel linux-headers dialog os-prober mtools dosfstools git kitty --noconfirm --needed
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable NetworkManager
echo "Enter user name: "
read NUSER

useradd -m -G wheel {$NUSER}
passwd {$NUSER}
echo "%wheel ALL=(ALL)" << /etc/sudoers
EOF






