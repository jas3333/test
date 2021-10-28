#! /bin/bash

mkdir AUR
cd AUR
git clone https://aur.archlinux.org/yay
cd yay
makepkg -si --noconfirm

# Get configs
cd
git clone https://github.com/jas3333/dotfiles.git

cp -r dotfiles/.config ~/.config
cp -r dotfiles/.wallpapers ~/.wallpapers
cp -r dotfiles/.local ~/.local
fc-cache

read -p "Do you need the nvidia drivers? <y or anything else to skip.>" nvidia
case $nvidia in
    y|Y|Yes|yes)
    echo "[multilib]" >> /etc/pacman.conf
    echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
    sudo pacman -S --needed nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader --noconfirm
esac

# Install Package list
PKGS=(
    'mesa'
    'xorg'
    'xorg-server'
    'python-pywal'
    'python-pip'
    'pipewire'
    'pipewire-alsa'
    'pipewire-jack'
    'pipewire-pulse'
    'mpv'
    'neofetch'
    'cmatrix'
    'pcmanfm'
    'bluez-utils'
    'bluez-libs'
    'nomacs'
    'discord'
    'sddm'
    'qtile'
    'steam'
    'filezilla'
    'ark'
    'p7zip'
    'zsh'
    'zsh-syntax-highlighting'
    'zsh-autosuggestions'
    'zip'
)

for PKG in "${PKGS[@]}"; do
    echo "Installing.... ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed
done

sudo systemctl enable sddm

sudo echo "net.ipv4.tcp_rmem=40960 873800 62914560" >> /etc/sysctl.d/99-sysctl.conf
sudo echo "net.core.rmem_mag=25000000" >> /etc/sysctl.d/99-sysctl.conf


