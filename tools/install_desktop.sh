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

function install_essentials()
{
  sudo curl -o /root/.bashrc \
  https://raw.githubusercontent.com/astaos/arch-configs/master/configs/.bashrc
  sudo cp /root/.bashrc $HOME/.bashrc

  sudo pacman -Syu
  sudo pacman -S --needed --noconfirm git wget rsync unzip
  sudo pacman -S --needed --noconfirm inetutils iptables net-tools
  sudo pacman -S --needed --noconfirm base-devel bc openssh samba
  sudo systemctl enable iptables.service
}

function install_dm()
{
  echo
  echo
  lspci -v | grep -A1 -e VGA -e 3D
  sudo pacman -Ss xf86-video
  echo
  read -p "Enter the xf86-video drvier: " -i "xf86-video-" -e GPU_DRIVER

  sudo pacman -S --needed --noconfirm ${GPU_DRIVER} || error_exit "Wrong driver is selected."
  sudo pacman -S --needed --noconfirm xorg xorg-server xorg-xrdb xorg-xrandr
  sudo pacman -S --needed --noconfirm libdrm sddm
  sudo systemctl enable sddm.service
}

function install_wm()
{
  sudo pacman -S --needed --noconfirm openbox picom nitrogen cairo-dock tint2 dunst
  sudo pacman -S --needed --noconfirm lxappearance lxappearance-obconf lxinput arandr
}

function install_others()
{
  sudo pacman -S --needed --noconfirm pulseaudio pulseaudio-alsa pulseaudio-bluetooth
  sudo pacman -S --needed --noconfirm mpd brightnessctl powertop
}

function install_system_apps()
{
  sudo pacman -S --needed --noconfirm xfce4-power-manager network-manager-applet blueman
  sudo pacman -S --needed --noconfirm pavucontrol ibus ibus-libpinyin ibus-hangul
  sudo pacman -S --needed --noconfirm thunar thunar-volman thunar-archive-plugin
  sudo pacman -S --needed --noconfirm tumbler ffmpegthumbnailer gvfs file-roller
}

function install_user_apps()
{
  sudo pacman -S --needed --noconfirm chromium alacritty vscode gimp inkscape
  sudo pacman -S --needed --noconfirm viewnior mpv mpc ncmpcpp parcellite
  sudo pacman -S --needed --noconfirm htop neofetch gsimplecal
}

function install_aur()
{
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

  # 404 error
  #git clone https://aur.archlinux.org/thunar-shares-plugin.git $HOME/.aur/thunar-shares-plugin
  #cd $HOME/.aur/thunar-shares-plugin
  #makepkg -si --noconfirm
}

function install_fonts()
{
  mkdir -p $HOME/.local/share/fonts/
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/JetBrainsMono.zip
  unzip JetBrainsMono.zip -d $HOME/.local/share/fonts/
  rm JetBrainsMono.zip
}




#==
#   Starting Code in below.
#/

if [[ $EUID -eq 0 ]]; then
  error_exit "This script must be run as USER!"
fi


##======================
#-- Essentials
install_essentials || error_exit "Essentials installation failed."


##======================
#-- [VIEW] X server & DM
install_dm || error_exit "X server & DM installation failed."

#-- [VIEW] WM
install_wm || error_exit "WM installation failed."

#-- [SYS] Others
install_others || error_exit "Other systems installation failed."

#-- [APPS] System apps
install_system_apps || error_exit "System apps installation failed."

#-- [APPS] User apps
install_user_apps || error_exit "User apps installation failed."


##======================
#-- AUR
install_aur || error_exit "AUR installation failed."


##======================
#-- Fonts
install_fonts || error_exit "Fonts installation failed."


##======================
#-- END
cd $HOME
script_print_notify "All successfully done.\n"
