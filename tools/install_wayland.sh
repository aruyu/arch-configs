#!/bin/bash
#==
#   NOTE      - install_wayland.sh
#   Author    - Aru
#
#   Created   - 2023.05.10
#   Github    - https://github.com/aruyu
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
  https://raw.githubusercontent.com/aruyu/arch-configs/master/configs/.bashrc
  sudo cp /root/.bashrc $HOME/.bashrc

  sudo pacman -Syu
  sudo pacman -S --needed --noconfirm pacman-contrib base-devel bc
  sudo pacman -S --needed --noconfirm git wget rsync unzip
  sudo pacman -S --needed --noconfirm inetutils iptables net-tools openssh samba
  sudo systemctl enable iptables.service

  sudo pacman -S --needed --noconfirm python python-pip ruby jq
  pip3 install --upgrade pip wheel setuptools
  pip3 install psutil
}

function install_dm()
{
  sudo pacman -S --needed --noconfirm wayland libdrm
  sudo pacman -S --needed --noconfirm gdm
  sudo systemctl enable gdm.service
}

function install_wm()
{
  sudo pacman -S --needed --noconfirm hyprland swaybg waybar swaylock dunst
}

function install_others()
{
  sudo pacman -S --needed --noconfirm pulseaudio pulseaudio-alsa pulseaudio-bluetooth
  sudo pacman -S --needed --noconfirm mpd gammastep
}

function install_system_apps()
{
  sudo pacman -S --needed --noconfirm network-manager-applet blueman
  sudo pacman -S --needed --noconfirm pavucontrol ibus ibus-libpinyin ibus-hangul
  sudo pacman -S --needed --noconfirm thunar thunar-volman thunar-archive-plugin
  sudo pacman -S --needed --noconfirm tumbler ffmpegthumbnailer gvfs file-roller
}

function install_user_apps()
{
  sudo pacman -S --needed --noconfirm chromium firefox alacritty vscode
  sudo pacman -S --needed --noconfirm libreoffice-still gimp inkscape xournalpp viewnior
  sudo pacman -S --needed --noconfirm mpv mpc ncmpcpp parcellite grim slurp
  sudo pacman -S --needed --noconfirm htop neofetch gsimplecal qalculate-gtk

  sudo pacman -S --needed --noconfirm docker minicom
  sudo systemctl enable docker.service
  sudo usermod -aG docker $USER
}

function install_aur()
{
  AUR_DIR=$HOME/.cache/pacaur

  git clone https://aur.archlinux.org/debtap.git ${AUR_DIR}/debtap
  cd ${AUR_DIR}/debtap
  makepkg -si --noconfirm

  git clone https://aur.archlinux.org/font-symbola.git ${AUR_DIR}/font-symbola
  cd ${AUR_DIR}/font-symbola
  makepkg -si --noconfirm

  git clone https://aur.archlinux.org/nwg-dock-hyprland.git ${AUR_DIR}/nwg-dock-hyprland
  cd ${AUR_DIR}/nwg-dock-hyprland
  makepkg -si --noconfirm

  git clone https://aur.archlinux.org/nwg-launchers.git ${AUR_DIR}/nwg-launchers
  cd ${AUR_DIR}/nwg-launchers
  makepkg -si --noconfirm

  git clone https://aur.archlinux.org/nwg-look.git ${AUR_DIR}/nwg-look
  cd ${AUR_DIR}/nwg-look
  makepkg -si --noconfirm

  git clone https://aur.archlinux.org/pa-applet-git.git ${AUR_DIR}/pa-applet-git
  cd ${AUR_DIR}/pa-applet-git
  makepkg -si --noconfirm

  #sudo pacman -S lib32-mesa-libgl
  #git clone https://aur.archlinux.org/playonlinux.git ${AUR_DIR}/playonlinux
  #cd ${AUR_DIR}/playonlinux
  #makepkg -si --noconfirm

  git clone https://aur.archlinux.org/psuinfo.git ${AUR_DIR}/psuinfo
  cd ${AUR_DIR}/psuinfo
  makepkg -si --noconfirm

  git clone https://aur.archlinux.org/sysmontask.git ${AUR_DIR}/sysmontask
  cd ${AUR_DIR}/sysmontask
  makepkg -si --noconfirm

  git clone https://aur.archlinux.org/thunar-shares-plugin.git ${AUR_DIR}/thunar-shares-plugin
  cd ${AUR_DIR}/thunar-shares-plugin
  makepkg -si --noconfirm

  git clone https://aur.archlinux.org/wdisplays.git ${AUR_DIR}/wdisplays
  cd ${AUR_DIR}/wdisplays
  makepkg -si --noconfirm

  git clone https://aur.archlinux.org/wlr-randr.git ${AUR_DIR}/wlr-randr
  cd ${AUR_DIR}/wlr-randr
  makepkg -si --noconfirm
}

function install_fonts()
{
  mkdir -p $HOME/.local/share/fonts/
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/JetBrainsMono.zip
  unzip JetBrainsMono.zip -d $HOME/.local/share/fonts/
  rm JetBrainsMono.zip

  sudo pacman -S --needed --noconfirm noto-fonts-cjk noto-fonts-emoji
  sudo pacman -S --needed --noconfirm font-manager
  sudo pacman -S --needed papirus-icon-theme
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
install_dm || error_exit "Wayland & DM installation failed."

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
#-- Fonts & Icons
install_fonts || error_exit "Fonts and icons installation failed."


##======================
#-- END
cd $HOME
mkdir Desktop Documents Downloads Music Pictures Videos
script_print_notify "All successfully done.\n"
