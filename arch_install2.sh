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

PKGS=(
    'grub'
    'efibootmgr'
    'networkmanager'
    'network-manager-applet'
    'openssh'
    'wireless_tools'
    'base-devel'
    'linux-headers'
    'dialog'
    'os-prober'
    'mtools'
    'dosfstools'
    'git'
    'kitty'
    'sudo'
)

for PKG in "${PKGS[@]}"; do
    echo "Installing....${PKG}"
    pacman -S "$PKG" --noconfirm --needed
done


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

echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
systemctl enable NetworkManager

echo "net.ipv4.tcp_rmem=40960 873800 62914560" >> /etc/sysctl.d/99-sysctl.conf
echo "net.core.rmem_mag=25000000" >> /etc/sysctl.d/99-sysctl.conf

