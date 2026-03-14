#!/bin/bash
#==
#   NOTE      - install_gnome.sh
#   Author    - Aru
#
#   Created   - 2024.11.14
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
  sudo pacman -S --needed --noconfirm pacman-contrib base-devel bc gdb
  sudo pacman -S --needed --noconfirm git wget net-tools inetutils usbutils
  sudo pacman -S --needed --noconfirm zip unzip unrar cpio rsync netcat fd
  sudo pacman -S --needed --noconfirm tcpdump iptables openssh openvpn networkmanager-openvpn samba
  sudo systemctl enable iptables.service

  sudo pacman -S --needed --noconfirm python python-pip python-setuptools
  sudo pacman -S --needed --noconfirm nodejs npm yarn ruby jq rustup man
  rustup default stable
}

function install_dm()
{
  sudo pacman -S --needed --noconfirm gnome gdm
  sudo pacman -S --needed --noconfirm xdg-desktop-portal-gnome xorg-xhost
  sudo systemctl enable gdm.service
}

function install_system_apps()
{
  sudo pacman -S --needed --noconfirm gnome-shell-extensions extension-manager gnome-tweaks dconf-editor
  sudo pacman -S --needed --noconfirm nautilus nautilus-share file-roller ntfs-3g
  sudo pacman -S --needed --noconfirm gvfs gvfs-afc gvfs-goa gvfs-google gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb
  sudo pacman -S --needed --noconfirm ibus ibus-hangul ibus-anthy ibus-rime
  sudo su <<-REALEND
	cat >> /etc/environment <<-EOF
	GTK_IM_MODULE=ibus
	QT_IM_MODULE=ibus
	XMODIFIERS=@im=ibus
EOF
REALEND
}

function install_user_apps()
{
  sudo pacman -S --needed --noconfirm chromium firefox gnome-terminal
  sudo pacman -S --needed --noconfirm libreoffice-still gimp inkscape rnote
  sudo pacman -S --needed --noconfirm htop fastfetch

  sudo pacman -S --needed --noconfirm docker docker-compose minicom putty freerdp
  sudo systemctl enable docker.service
  sudo usermod -aG docker,tty,uucp $USER
}

function install_aur()
{
  AUR_DIR=$HOME/.cache/yay

  git clone https://aur.archlinux.org/yay.git ${AUR_DIR}/yay
  cd ${AUR_DIR}/yay
  makepkg -si --noconfirm

  yay -S --needed --noconfirm debtap
  yay -S --needed --noconfirm downgrade
  yay -S --needed --noconfirm grub-customizer

  yay -S --needed --noconfirm rate-mirrors
  yay -S --needed --noconfirm ttf-symbola
  yay -S --needed --noconfirm tty-clock

  #sudo pacman -S lib32-mesa-libgl
  #git clone https://aur.archlinux.org/playonlinux.git ${AUR_DIR}/playonlinux
  #cd ${AUR_DIR}/playonlinux
  #makepkg -si --noconfirm
}

function install_fonts()
{
  mkdir -p $HOME/.local/share/fonts/
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/JetBrainsMono.zip
  unzip JetBrainsMono.zip -d $HOME/.local/share/fonts/
  rm JetBrainsMono.zip

  sudo pacman -S --needed --noconfirm noto-fonts-cjk noto-fonts-emoji noto-fonts-extra
  sudo pacman -S --needed --noconfirm noto-fonts font-manager
  sudo pacman -S --needed --noconfirm papirus-icon-theme
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
#install_wm || error_exit "WM installation failed."

#-- [SYS] Others
#install_others || error_exit "Other systems installation failed."

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
