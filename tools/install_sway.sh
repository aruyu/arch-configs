#!/bin/bash
#==
#   NOTE      - install_sway.sh
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
  sudo pacman -S --needed --noconfirm pacman-contrib base-devel bc gdb
  sudo pacman -S --needed --noconfirm git wget rsync unzip cpio inetutils net-tools usbutils
  sudo pacman -S --needed --noconfirm iptables openssh openvpn networkmanager-openvpn samba
  sudo systemctl enable iptables.service

  sudo pacman -S --needed --noconfirm python python-pip python-setuptools
  sudo pacman -S --needed --noconfirm nodejs npm yarn ruby jq rustup man
  rustup default stable
}

function install_dm()
{
  sudo pacman -S --needed --noconfirm wayland wayland-utils libdrm gdm
  sudo pacman -S --needed --noconfirm xdg-desktop-portal-wlr xdg-desktop-portal-gnome
  sudo systemctl enable gdm.service
}

function install_wm()
{
  sudo pacman -S --needed --noconfirm sway swaybg swaylock swayidle waybar
  sudo pacman -S --needed --noconfirm dunst wofi
}

function install_others()
{
  sudo pacman -S --needed --noconfirm pulseaudio pulseaudio-alsa pulseaudio-bluetooth
  sudo pacman -S --needed --noconfirm mpd brightnessctl pamixer
}

function install_system_apps()
{
  sudo pacman -S --needed --noconfirm network-manager-applet blueman pavucontrol
  sudo pacman -S --needed --noconfirm nautilus nautilus-share file-roller ntfs-3g
  sudo pacman -S --needed --noconfirm gvfs gvfs-afc gvfs-goa gvfs-google gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb
  sudo pacman -S --needed --noconfirm fcitx fcitx-libpinyin fcitx-mozc fcitx-hangul fcitx-configtool
  sudo su <<-REALEND
	cat >> /etc/environment <<-EOF
	GTK_IM_MODULE=fcitx
	QT_IM_MODULE=fcitx
	XMODIFIERS=@im=fcitx
EOF
REALEND
}

function install_user_apps()
{
  sudo pacman -S --needed --noconfirm chromium firefox foot
  sudo pacman -S --needed --noconfirm libreoffice-still gimp inkscape rnote
  sudo pacman -S --needed --noconfirm mpv mpc ncmpcpp viewnior copyq grim slurp wl-clipboard
  sudo pacman -S --needed --noconfirm htop neofetch gsimplecal wev evtest

  sudo pacman -S --needed --noconfirm docker docker-compose minicom remmina freerdp
  sudo systemctl enable docker.service
  sudo usermod -aG docker,tty,uucp $USER
}

function install_aur()
{
  AUR_DIR=$HOME/.cache/trizen/sources

  git clone https://aur.archlinux.org/trizen.git ${AUR_DIR}/trizen
  cd ${AUR_DIR}/trizen
  makepkg -si --noconfirm

  trizen -S --needed --noconfirm autotiling --sudo-autorepeat-at-runtime
  trizen -S --needed --noconfirm avizo --sudo-autorepeat-at-runtime
  trizen -S --needed --noconfirm catppuccin-cursors-frappe --sudo-autorepeat-at-runtime
  sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface cursor-theme Catppuccin-Frappe-Dark-Cursors

  trizen -S --needed --noconfirm debtap --sudo-autorepeat-at-runtime
  trizen -S --needed --noconfirm downgrade --sudo-autorepeat-at-runtime
  trizen -S --needed --noconfirm gtkterm --sudo-autorepeat-at-runtime

  trizen -S --needed --noconfirm nwg-launchers --sudo-autorepeat-at-runtime
  trizen -S --needed --noconfirm nwg-look --sudo-autorepeat-at-runtime
  trizen -S --needed --noconfirm pasystray-wayland --sudo-autorepeat-at-runtime

  trizen -S --needed --noconfirm rate-mirrors --sudo-autorepeat-at-runtime
  trizen -S --needed --noconfirm ttf-symbola --sudo-autorepeat-at-runtime
  trizen -S --needed --noconfirm tty-clock --sudo-autorepeat-at-runtime

  trizen -S --needed --noconfirm uno-calculator-bin --sudo-autorepeat-at-runtime
  trizen -S --needed --noconfirm uxplay --sudo-autorepeat-at-runtime
  trizen -S --needed --noconfirm visual-studio-code-bin --sudo-autorepeat-at-runtime

  trizen -S --needed --noconfirm wayout-git --sudo-autorepeat-at-runtime
  trizen -S --needed --noconfirm wdisplays --sudo-autorepeat-at-runtime

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
