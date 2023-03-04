#!/bin/bash
#==
#   NOTE      - install_desktop.sh
#   Author    - Asta
#
#   Created   - 2023.02.22
#   Github    - https://github.com/astaos
#   Contact   - vine9151@gmail.com
#/



T_CO_RED='\e[1;31m'
T_CO_YELLOW='\e[1;33m'
T_CO_GREEN='\e[1;32m'
T_CO_BLUE='\e[1;34m'
T_CO_GRAY='\e[1;30m'
T_CO_NC='\e[0m'

CURRENT_PROGRESS=0

function script_print()
{
  echo -ne "$T_CO_BLUE[SCRIPT]$T_CO_NC$1"
}

function script_print_notify()
{
  echo -ne "$T_CO_BLUE[SCRIPT]$T_CO_NC$T_CO_GREEN-Notify- $1$T_CO_NC"
}

function script_print_error()
{
  echo -ne "$T_CO_BLUE[SCRIPT]$T_CO_NC$T_CO_RED-Error- $1$T_CO_NC"
}

function error_exit()
{
  script_print_error "$1\n\n"
  exit 1
}




#==
#   Starting Code in below.
#/

if [[ $EUID -eq 0 ]]; then
  error_exit "This script must be run as USER!"
fi


##======================
#-- Essentials
sudo curl -o $HOME/.bashrc \
https://raw.githubusercontent.com/astaos/arch-configs/master/configs/.bashrc

sudo pacman -Syu
sudo pacman -S --needed --noconfirm git unzip rsync wget inetutils
sudo pacman -S --needed --noconfirm net-tools iw openssh samba
sudo pacman -S --needed --noconfirm psmisc base-devel bc


##======================
#-- [VIEW] X server & DM
lspci -v | grep -A1 -e VGA -e 3D
sudo pacman -Ss xf86-video
read -p "Enter the xf86-video drvier: " -i "xf86-video-" -e GPU_DRIVER

sudo pacman -S --needed --noconfirm ${GPU_DRIVER} || error_exit "wrong driver selected."
sudo pacman -S --needed --noconfirm xorg xorg-server xorg-xrdb xorg-xrandr
sudo pacman -S --needed --noconfirm libdrm sddm
sudo systemctl enable sddm.service

#-- [VIEW] WM
sudo pacman -S --needed --noconfirm openbox picom nitrogen plank tint2 dunst
sudo pacman -S --needed --noconfirm lxappearance lxappearance-obconf lxinput lxrandr

#-- [SYS] Others
sudo pacman -S --needed --noconfirm pulseaudio pulseaudio-alsa mpd brightnessctl

#-- [APPS] System apps
sudo pacman -S --needed --noconfirm xfce4-power-manager network-manager-applet
sudo pacman -S --needed --noconfirm pavucontrol ibus ibus-libpinyin ibus-hangul
sudo pacman -S --needed --noconfirm thunar thunar-volman thunar-archive-plugin
sudo pacman -S --needed --noconfirm tumbler ffmpegthumbnailer gvfs file-roller

#-- [APPS] User apps
sudo pacman -S --needed --noconfirm chromium alacritty vscode gimp inkscape
sudo pacman -S --needed --noconfirm viewnior mpv mpc ncmpcpp htop neofetch


##======================
#-- AUR
git clone https://aur.archlinux.org/ttf-nanum.git $HOME/.aur/ttf-nanum
cd $HOME/.aur/ttf-nanum
makepkg -si --noconfirm

git clone https://aur.archlinux.org/ttf-monapo.git $HOME/.aur/ttf-monapo
cd $HOME/.aur/ttf-monapo
makepkg -si --noconfirm

git clone https://aur.archlinux.org/perl-linux-desktopfiles.git $HOME/.aur/perl-linux-desktopfiles
git clone https://aur.archlinux.org/obmenu-generator.git $HOME/.aur/obmenu-generator
cd $HOME/.aur/perl-linux-desktopfiles
makepkg -si --noconfirm
cd $HOME/.aur/obmenu-generator
makepkg -si --noconfirm

git clone https://aur.archlinux.org/obkey.git $HOME/.aur/obkey
cd $HOME/.aur/obkey
makepkg -si --noconfirm

git clone https://aur.archlinux.org/obapps.git $HOME/.aur/obapps
cd $HOME/.aur/obapps
makepkg -si --noconfirm

# 404 error
#git clone https://aur.archlinux.org/thunar-shares-plugin.git $HOME/.aur/thunar-shares-plugin
#cd $HOME/.aur/thunar-shares-plugin
#makepkg -si --noconfirm


##======================
#-- Fonts
mkdir -p $HOME/.local/share/fonts/
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/JetBrainsMono.zip
unzip JetBrainsMono.zip -d $HOME/.local/share/fonts/
rm JetBrainsMono.zip


##======================
#-- END
cd $HOME
script_print_notify "All successfully done.\n"
