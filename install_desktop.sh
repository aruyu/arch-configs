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

function delay()
{
  sleep 0.2;
}

function progress()
{
  PARAM_PROGRESS=$1;
  PARAM_PHASE=$2;

  if [  $CURRENT_PROGRESS -le 0 -a $PARAM_PROGRESS -ge 0  ]; then
    script_print "[$T_CO_GRAY........................................$T_CO_NC] (0%)  $PARAM_PHASE                    \r" ; delay; fi;

  if [  $CURRENT_PROGRESS -le 5 -a $PARAM_PROGRESS -ge 5  ]; then
    script_print "[$T_CO_RED>>$T_CO_NC$T_CO_GRAY......................................$T_CO_NC] (5%)  $PARAM_PHASE                    \r" ; delay; fi;

  if [ $CURRENT_PROGRESS -le 10 -a $PARAM_PROGRESS -ge 10 ]; then
    script_print "[$T_CO_RED>>>>$T_CO_NC$T_CO_GRAY....................................$T_CO_NC] (10%) $PARAM_PHASE                    \r" ; delay; fi;

  if [ $CURRENT_PROGRESS -le 15 -a $PARAM_PROGRESS -ge 15 ]; then
    script_print "[$T_CO_RED>>>>>>$T_CO_NC$T_CO_GRAY..................................$T_CO_NC] (15%) $PARAM_PHASE                    \r" ; delay; fi;

  if [ $CURRENT_PROGRESS -le 20 -a $PARAM_PROGRESS -ge 20 ]; then
    script_print "[$T_CO_RED>>>>>>>>$T_CO_NC$T_CO_GRAY................................$T_CO_NC] (20%) $PARAM_PHASE                    \r" ; delay; fi;

  if [ $CURRENT_PROGRESS -le 25 -a $PARAM_PROGRESS -ge 25 ]; then
    script_print "[$T_CO_RED>>>>>>>>>>$T_CO_NC$T_CO_GRAY..............................$T_CO_NC] (25%) $PARAM_PHASE                    \r" ; delay; fi;

  if [ $CURRENT_PROGRESS -le 30 -a $PARAM_PROGRESS -ge 30 ]; then
    script_print "[$T_CO_RED>>>>>>>>>>>>$T_CO_NC$T_CO_GRAY............................$T_CO_NC] (30%) $PARAM_PHASE                    \r" ; delay; fi;

  if [ $CURRENT_PROGRESS -le 35 -a $PARAM_PROGRESS -ge 35 ]; then
    script_print "[$T_CO_RED>>>>>>>>>>>>>>$T_CO_NC$T_CO_GRAY..........................$T_CO_NC] (35%) $PARAM_PHASE                    \r" ; delay; fi;

  if [ $CURRENT_PROGRESS -le 40 -a $PARAM_PROGRESS -ge 40 ]; then
    script_print "[$T_CO_RED>>>>>>>>>>>>>>>>$T_CO_NC$T_CO_GRAY........................$T_CO_NC] (40%) $PARAM_PHASE                    \r" ; delay; fi;

  if [ $CURRENT_PROGRESS -le 45 -a $PARAM_PROGRESS -ge 45 ]; then
    script_print "[$T_CO_YELLOW>>>>>>>>>>>>>>>>>>$T_CO_NC$T_CO_GRAY......................$T_CO_NC] (45%) $PARAM_PHASE                    \r" ; delay; fi;

  if [ $CURRENT_PROGRESS -le 50 -a $PARAM_PROGRESS -ge 50 ]; then
    script_print "[$T_CO_YELLOW>>>>>>>>>>>>>>>>>>>>$T_CO_NC$T_CO_GRAY....................$T_CO_NC] (50%) $PARAM_PHASE                    \r" ; delay; fi;

  if [ $CURRENT_PROGRESS -le 55 -a $PARAM_PROGRESS -ge 55 ]; then
    script_print "[$T_CO_YELLOW>>>>>>>>>>>>>>>>>>>>>>$T_CO_NC$T_CO_GRAY..................$T_CO_NC] (55%) $PARAM_PHASE                    \r" ; delay; fi;

  if [ $CURRENT_PROGRESS -le 60 -a $PARAM_PROGRESS -ge 60 ]; then
    script_print "[$T_CO_YELLOW>>>>>>>>>>>>>>>>>>>>>>>>$T_CO_NC$T_CO_GRAY................$T_CO_NC] (60%) $PARAM_PHASE                    \r" ; delay; fi;

  if [ $CURRENT_PROGRESS -le 65 -a $PARAM_PROGRESS -ge 65 ]; then
    script_print "[$T_CO_YELLOW>>>>>>>>>>>>>>>>>>>>>>>>>>$T_CO_NC$T_CO_GRAY..............$T_CO_NC] (65%) $PARAM_PHASE                    \r" ; delay; fi;

  if [ $CURRENT_PROGRESS -le 70 -a $PARAM_PROGRESS -ge 70 ]; then
    script_print "[$T_CO_YELLOW>>>>>>>>>>>>>>>>>>>>>>>>>>>>$T_CO_NC$T_CO_GRAY............$T_CO_NC] (70%) $PARAM_PHASE                    \r" ; delay; fi;

  if [ $CURRENT_PROGRESS -le 75 -a $PARAM_PROGRESS -ge 75 ]; then
    script_print "[$T_CO_YELLOW>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$T_CO_NC$T_CO_GRAY..........$T_CO_NC] (75%) $PARAM_PHASE                    \r" ; delay; fi;

  if [ $CURRENT_PROGRESS -le 80 -a $PARAM_PROGRESS -ge 80 ]; then
    script_print "[$T_CO_YELLOW>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$T_CO_NC$T_CO_GRAY........$T_CO_NC] (80%) $PARAM_PHASE                    \r" ; delay; fi;

  if [ $CURRENT_PROGRESS -le 85 -a $PARAM_PROGRESS -ge 85 ]; then
    script_print "[$T_CO_GREEN>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$T_CO_NC$T_CO_GRAY......$T_CO_NC] (85%) $PARAM_PHASE                    \r" ; delay; fi;

  if [ $CURRENT_PROGRESS -le 90 -a $PARAM_PROGRESS -ge 90 ]; then
    script_print "[$T_CO_GREEN>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$T_CO_NC$T_CO_GRAY....$T_CO_NC] (90%) $PARAM_PHASE                    \r" ; delay; fi;

  if [ $CURRENT_PROGRESS -le 95 -a $PARAM_PROGRESS -ge 95 ]; then
    script_print "[$T_CO_GREEN>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>$T_CO_NC] (100%) $PARAM_PHASE                    \r" ; delay; fi;

  if [ $CURRENT_PROGRESS -le 100 -a $PARAM_PROGRESS -ge 100 ]; then
    echo
    script_print_notify "Progress Done!                                                                                \n" ; delay; fi;

  CURRENT_PROGRESS=$PARAM_PROGRESS;
}




#==
#   Starting Code in below.
#/

if [[ $EUID -eq 0 ]]; then
  script_print_error "This script must be run as USER!\n"
  exit 1
fi


#-- Install essentials
sudo pacman -S --needed --noconfirm vim git wget net-tools iw
sudo pacman -S --needed --noconfirm psmisc base-devel
sudo ln -s /usr/bin/vim /usr/bin/vi


#-- [VIEW] X server & DM
lspci -v | grep -A1 -e VGA -e 3D
sudo pacman -Ss xf86-video
read -p "Enter the xf86-video drvier: " -i "xf86-video-" -e GPU_DRIVER

sudo pacman -S --needed --noconfirm ${GPU_DRIVER} xorg xorg-server xorg-xrdb xorg-xrandr
sudo pacman -S --needed --noconfirm sddm
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
