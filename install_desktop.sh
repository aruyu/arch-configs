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


#-- Install essentials
sudo pacman -S --needed --noconfirm vim git wget net-tools iw
sudo pacman -S --needed --noconfirm psmisc base-devel
sudo ln -s /usr/bin/vim /usr/bin/vi


#-- [VIEW] X server & DM
lspci -v | grep -A1 -e VGA -e 3D
sudo pacman -Ss xf86-video
read -p "Enter the xf86-video drvier: " -i "xf86-video-" -e GPU_DRIVER

sudo pacman -S --needed --noconfirm ${GPU_DRIVER} || error_exit "wrong driver selected."
sudo pacman -S --needed --noconfirm xorg xorg-server xorg-xrdb xorg-xrandr sddm
sudo systemctl enable sddm.service

#-- [VIEW] WM
sudo pacman -S --needed --noconfirm openbox lxappearance lxappearance-obconf
sudo pacman -S --needed --noconfirm nitrogen plank tint2 picom dunst

#-- [SYS] System
sudo pacman -S --needed --noconfirm libdrm brightnessctl iwd bluez bluez-utils
sudo systemctl enable bluetooth.service

sudo curl -o /etc/systemd/system/rfkill-unblock-all.service \
https://raw.githubusercontent.com/astaos/arch-configs/master/rfkill-unblock-all.service
sudo systemctl enable rfkill-unblock-all.service

#-- [SYS] Audio
sudo pacman -S --needed --noconfirm pulseaudio pulseaudio-alsa mpd

#-- [SYS] fonts
sudo pacman -S --needed --noconfirm ibus ibus-libpinyin ibus-hangul

#-- [APPS] System apps
sudo pacman -S --needed --noconfirm arandr pavucontrol xfce4-power-manager
sudo pacman -S --needed --noconfirm thunar thunar-volman thunar-archive-plugin

#-- [APPS] User apps
sudo pacman -S --needed --noconfirm alacritty vscode viewnior mpv mpc ncmpcpp gimp inkscape
sudo pacman -S --needed --noconfirm htop neofetch
