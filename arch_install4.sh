#! /bin/bash

cd
mkdir AUR
cd AUR
git clone https://aur.archlinux.org/yay
cd yay
makepkg -si --noconfirm


# Install AUR packages
PKGS=(
    'sddm-sugar-candy-git'
    'librewolf-bin'
    'brave-bin'
)

sudo yay -Sy
for PKG in "${PKGS[@]}"; do
    echo "Installing.... ${PKG}"
    yay -S "$PKG" --noconfirm --needed
done

sudo sed -i '33d' /usr/lib/sddm/sddm.conf.d/default.conf
sudo sed -i '33iCurrent=sugar-candy' /usr/lib/sddm/sddm.conf.d/default.conf

cd
git clone https://github.com/jas3333/dotfiles.git
cp -r dotfiles/.config ~/
cp -r dotfiles/.wallpapers ~/
cp -r dotfiles/.local ~/
cp -r dotfiles/.themes ~/
cp -r dotfiles/.vim ~/
cp -r dotfiles/.vimrc ~/
fc-cache

pip install psutil

#cat <<EOF > ~/.Xresources
#Xft.dpi: 192
#rofi.dpi:192
#qtile.dpi:192
#Xcursor.theme: Adwaita
#Xcursor.size:48
#EOF
#

