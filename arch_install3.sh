#! /bin/bash

read -p "Do you need the nvidia drivers? <y or anything else to skip.>" nvidia
case $nvidia in
    y|Y|Yes|yes)
    echo "[multilib]" >> /etc/pacman.conf
    echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
    sudo pacman -Sy
    NV=(
        'nvidia-dkms'
        'nvidia-utils'
        'lib32-nvidia-utils'
        'nvidia-settings'
        'vulkan-icd-loader'
        'lib32-vulkan-icd-loader'
    )

    for NVPKG in "${NV[@]}"; do
        echo "Installing.... ${NVPKG}"
        sudo pacman -S "$NVPKG" --noconfirm --needed
    done
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
    'rofi'
    'lxappearance'
    'dunst'
    'python-dbus-next'
    'bashtop'
    'htop'
    'pacman-contrib'
    'picom'
)

for PKG in "${PKGS[@]}"; do
    echo "Installing.... ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed
done

sudo systemctl enable sddm




