#! /bin/bash

# Install AUR packages
PKGS=(
    'sddm-sugar-candy-git'
    'librewolf-bin'
    'brave-bin'
)


for PKG in "${PKGS[@]}"; do
    echo "Installing.... ${PKG}"
    yay -S "$PKG" --noconfirm --needed
done

sudo sed -i '33d' /usr/lib/sddm/sddm.conf.d/default.conf
sudo sed -i '33iCurrent=sugar-candy' /usr/lib/sddm/sddm.conf.d/default.conf
