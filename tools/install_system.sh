#!/bin/bash
#==
#   NOTE      - install_system.sh
#   Author    - Asta
#
#   Created   - 2023.02.21
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

function set_timezone()
{
  timedatectl list-timezones
  echo
  read -p "Enter the Timezone: " -e TIMEZONE
  timedatectl set-timezone ${TIMEZONE} || error_exit "Timezone setting failed."
  timedatectl status
}

function init_disk()
{
  echo
  fdisk -l
  echo
  read -p "Enter the Disk (at least 64GB): " -i "/dev/" -e DISK_PATH

  fdisk ${DISK_PATH} <<-EOF
	g
	p
	n
	1

	+512M
	n
	2

	+10G
	n
	3


	t
	1
	1
	t
	2
	19
	p
	w
EOF

  if [ ${DISK_PATH} = "/dev/sda" ]; then
    mkfs.ext4 /dev/sda3
    mkfs.fat -F 32 /dev/sda1
    mkswap /dev/sda2
  else
    mkfs.ext4 ${DISK_PATH}p3
    mkfs.fat -F 32 ${DISK_PATH}p1
    mkswap ${DISK_PATH}p2
  fi
}

function mount_disk()
{
  if [ ${DISK_PATH} = "/dev/sda" ]; then
    mount /dev/sda3 /mnt
    mount --mkdir /dev/sda1 /mnt/boot
    swapon /dev/sda2
  else
    mount ${DISK_PATH}p3 /mnt
    mount --mkdir ${DISK_PATH}p1 /mnt/boot
    swapon ${DISK_PATH}p2
  fi
}

function config_arch()
{
  echo
  read -p "Enter a new user name: " -e USER_NAME

  arch-chroot /mnt <<-REALEND
	ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
	hwclock --systohc

	sed -i 's/#en_US.UTF-8/en_US.UTF-8/g' /etc/locale.gen
	sed -i 's/#ja_JP.UTF-8/ja_JP.UTF-8/g' /etc/locale.gen
	sed -i 's/#ko_KR.UTF-8/ko_KR.UTF-8/g' /etc/locale.gen
	locale-gen
	cat >> /etc/locale.conf <<-EOF
	LANG=en_US.UTF-8
	LC_COLLATE=C
EOF

	echo 'arch' >> /etc/hostname
	cat >> /etc/hosts <<-EOF
	127.0.1.1  localhost
	::1        localhost
	127.0.1.1  arch
EOF

	cat >> /etc/modprobe.d/nobeep.conf <<-EOF
	blacklist pcspkr
	blacklist snd_pcsp
EOF

	pacman -S --needed --noconfirm networkmanager
	pacman -S --needed --noconfirm dhclient iwd

	systemctl stop --now wpa_supplicant.service
	killall wpa_supplicant
	systemctl mask wpa_supplicant.service

	cat >> /etc/NetworkManager/conf.d/dhcp-client.conf <<-EOF
	[main]
	dhcp=dhclient
EOF

	cat >> /etc/NetworkManager/conf.d/wifi-backend.conf <<-EOF
	[device]
	wifi.backend=iwd
	wifi.iwd.autoconnect=yes
EOF

	cat >> /etc/NetworkManager/conf.d/wifi-rand-mac.conf <<-EOF
	[device-mac-randomization]
	wifi.scan-rand-mac-address=yes

	[connection-mac-randomization]
	ethernet.cloned-mac-address=random
	wifi.cloned-mac-address=stable
EOF

	systemctl enable NetworkManager.service

	pacman -S --needed --noconfirm bluez bluez-utils
	systemctl enable bluetooth.service

	curl -o /etc/systemd/system/rfkill-unblock-all.service \
	https://raw.githubusercontent.com/astaos/arch-configs/master/configs/rfkill-unblock-all.service

	pacman -S --needed --noconfirm grub efibootmgr
	grub-install --target=x86_64-efi --efi-directory=/boot/ --bootloader-id=GRUB --removable
	sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub
	sed -i 's/GRUB_TIMEOUT_STYLE=menu/GRUB_TIMEOUT_STYLE=countdown/g' /etc/default/grub
	sed -i '/^GRUB_CMDLINE_LINUX_DEFAULT/s/"$/ btusb.enable_autosuspend=0"/' /etc/default/grub
	grub-mkconfig -o /boot/grub/grub.cfg

	passwd <<-EOF
	root
	root
EOF

	useradd -m -G users,wheel,audio,video -s /bin/bash ${USER_NAME}
	passwd ${USER_NAME} <<-EOF
	${USER_NAME}
	${USER_NAME}
EOF

	pacman -S --needed --noconfirm sudo vim
	sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/g' /etc/sudoers
	ln -s /usr/bin/vim /usr/bin/vi
REALEND
}




#==
#   Starting codes in blew
#/

if [[ $EUID -ne 0 ]]; then
  error_exit "This script must be run as ROOT!"
fi


rmmod pcspkr
rmmod snd_pcsp

set_timezone
init_disk || error_exit "Disk format failed."
mount_disk || error_exit "Disk mounting failed."

pacstrap -K /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab

config_arch || error_exit "Arch configuration failed."
fdisk -l
cat /mnt/etc/fstab
script_print_notify "Default passwords is all the same as ID.\n"
script_print_notify "Please change the passwords.\n"

umount -R /mnt
script_print_notify "All successfully done.\n"
