#!/bin/bash
#==
#   NOTE      - install_xorg.sh
#   Author    - Aru
#
#   Created   - 2023.02.22
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
  while true; do
    echo
    lspci -v | grep -A1 -e VGA -e 3D
    sudo pacman -Ss xf86-video
    echo
    read -p "Enter the xf86-video drvier: " -i "xf86-video-" -e SELECTION
    case ${SELECTION} in
      xf86-video-* )        script_print_notify "Selected video driver: ${SELECTION}.\n"; sleep 1;
                            sudo pacman -S --needed --noconfirm ${SELECTION} || error_exit "Wrong driver is selected.";
                            break;;
      [Ss][Kk][Ii][Pp] )    break;;
      * )                   echo "Wrong answer. (xf86-video-* or skip)";;
    esac
  done

  sudo pacman -S --needed --noconfirm xorg xorg-server xorg-xrdb xorg-xrandr libdrm
  sudo pacman -S --needed --noconfirm sddm qt5-graphicaleffects qt5-quickcontrols2 qt5-svg  # essentials
  sudo pacman -S --needed --noconfirm gst-libav phonon-qt5-gstreamer gst-plugins-good       # gst gif supports
  sudo pacman -S --needed --noconfirm qt5-quickcontrols qt5-multimedia
  sudo systemctl enable sddm.service
}

function install_wm()
{
  sudo pacman -S --needed --noconfirm openbox nitrogen tint2 jgmenu plank dunst
  sudo pacman -S --needed --noconfirm lxappearance lxappearance-obconf lxinput arandr
}

function install_others()
{
  sudo pacman -S --needed --noconfirm pulseaudio pulseaudio-alsa pulseaudio-bluetooth
  sudo pacman -S --needed --noconfirm mpd brightnessctl acpi
  #sudo systemctl enable tlp.service
  #sudo systemctl mask systemd-rfkill.service
  #sudo systemctl mask systemd-rfkill.socket
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
  sudo pacman -S --needed --noconfirm chromium firefox alacritty vscode
  sudo pacman -S --needed --noconfirm libreoffice-still gimp inkscape xournalpp viewnior
  sudo pacman -S --needed --noconfirm mpv mpc ncmpcpp parcellite xclip scrot
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

  git clone https://aur.archlinux.org/perl-linux-desktopfiles.git ${AUR_DIR}/perl-linux-desktopfiles
  git clone https://aur.archlinux.org/obmenu-generator.git ${AUR_DIR}/obmenu-generator
  cd ${AUR_DIR}/perl-linux-desktopfiles
  makepkg -si --noconfirm
  cd ${AUR_DIR}/obmenu-generator
  makepkg -si --noconfirm

  git clone https://aur.archlinux.org/pa-applet-git.git ${AUR_DIR}/pa-applet-git
  cd ${AUR_DIR}/pa-applet-git
  makepkg -si --noconfirm

  git clone https://aur.archlinux.org/picom-pijulius-git.git ${AUR_DIR}/picom-pijulius-git
  cd ${AUR_DIR}/picom-pijulius-git
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

  #sudo pacman -S tlp
  #git clone https://aur.archlinux.org/tlpui.git ${AUR_DIR}/tlpui
  #cd ${AUR_DIR}/tlpui
  #makepkg -si --noconfirm

  #git clone https://aur.archlinux.org/ttf-monapo.git ${AUR_DIR}/ttf-monapo
  #cd ${AUR_DIR}/ttf-monapo
  #makepkg -si --noconfirm

  #git clone https://aur.archlinux.org/ttf-nanum.git ${AUR_DIR}/ttf-nanum
  #cd ${AUR_DIR}/ttf-nanum
  #makepkg -si --noconfirm
}

function install_fonts()
{
  mkdir -p $HOME/.local/share/fonts/
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/JetBrainsMono.zip
  unzip JetBrainsMono.zip -d $HOME/.local/share/fonts/
  rm JetBrainsMono.zip

  sudo pacman -S --needed --noconfirm noto-fonts-cjk noto-fonts-emoji
  sudo pacman -S --needed --noconfirm font-manager
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
install_dm || error_exit "Xorg & DM installation failed."

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
mkdir Desktop Documents Downloads Music Pictures Videos
script_print_notify "All successfully done.\n"
