#!/bin/bash
#==
#   NOTE      - install_system.sh
#   Author    - Asta
#
#   Created   - 2023.02.21
#   Github    - https://github.com/astaos
#   Contact   - vine9151@gmail.com
#/


function error_exit()
{
  echo -ne "Error: $1\n"
  exit 1
}

function set_timezone()
{
  timedatectl list-timezones
  read -p "Enter the Timezone: " TIMEZONE
  timedatectl set-timezone ${TIMEZONE}
  timedatectl status
}

function init_disk()
{
  fdisk -l
  read -p "Enter the Disk: " -i "/dev/" -e DISK_PATH

  fdisk ${DISK_PATH} <<-EOF
	g
	p
	n
	1

	+512M
	y
	n
	2

	+10G
	y
	n
	3


	y

	t
	1
	1
	t
	2
	19
	p
	w
EOF

  mkfs.ext4 ${DISK_PATH}3
  mkfs.fat -F 32 ${DISK_PATH}1
  mkswap ${DISK_PATH}2
}

function mount_disk()
{
  mount ${DISK_PATH}3 /mnt
  mount --mkdir ${DISK_PATH}1 /mnt/boot
  swapon ${DISK_PATH}2
}

function config_arch()
{
  arch-chroot /mnt <<-EOF
	ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
	hwclock --systohc

	echo en_US.UTF-8 UTF-8 > /etc/locale.gen
	locale-gen
	echo LANG=en_US.UTF-8 > /etc/locale.conf

	echo arch > /etc/hostname
	echo 127.0.1.1  localhost > /etc/hosts
	echo ::1        localhost > /etc/hosts
	echo 127.0.1.1  arch > /etc/hosts

	pacman -S networkmanager
	systemctl enable NetworkManager
	passwd

	pacman -S grub efibootmgr
	grub-install --tartget=x86_64-efi --efi-directory=/boot/ --bootloader-id=GRUB --removable
	grub-mkconfig -o /boot/grub/grub.cfg
	exit
EOF
}


#==
#   Starting codes in blew
#/

ping -c 3 archlinux.org

set_timezone || error_exit "Timezone set failed."
init_disk || error_exit "Disk format failed."
mount_disk || error_exit "Disk mount failed."

pacstrap -K /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab

config_arch || error_exit "Arch root configure failed."

umount -R /mnt
