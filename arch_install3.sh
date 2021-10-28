#! /bin/bash

mkdir AUR
cd AUR
git clone https://aur.archlinux.org/yay
cd yay
makepkg -si --noconfirm

# Get configs
git clone https://github.com/jas3333/dotfiles.git

cp -r dotfiles/.config ~/.config
cp -r dotfiles/.wallpapers ~/.wallpapers
cp -r dotfiles/.local ~/.local
fc-cache

sudo pacman -S sddm qtile xorg xorg-server python-pywal python-pip

sudo systemctl enable sddm

