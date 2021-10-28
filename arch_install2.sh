#! /bin/bash
ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen

locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "arch" >> /etc/hostname
echo "127.0.0.1     localhost" >> /etc/hosts
echo "::1           localhost" >> /etc/hosts
echo "127.0.1.1     arch.localdomain    arch" >> /etc/hosts

pacman -S grub efibootmgr networkmanager network-manager-applet wireless_tools openssh base-devel linux-headers dialog os-prober mtools dosfstools git kitty sudo --noconfirm --needed

cd /
mkdir /boot/EFI
mount -L UEFISYS /boot/EFI

grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

read -p "Enter root password: " rpass
read -p "Enter username: " username
read -p "Enter user password: " upass

echo "Setting root password."
echo -en "$rpass\n$rpass" | passwd

echo "Creating new user."
useradd -m -G wheel $username
echo -en "$upass\n$upass" | passwd $username

echo "%wheel ALL=(ALL)" << /etc/sudoers
