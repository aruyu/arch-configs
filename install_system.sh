#!/bin/bash
#==
#   NOTE      - install_system.sh
#   Author    - Asta
#
#   Created   - 2023.02.21
#   Github    - https://github.com/astaos
#   Contact   - vine9151@gmail.com
#/


ping -c 3 archlinux.org
timedatectl set-timezone 'Asia/Seoul'
timedatectl status
fdisk -l

fdisk /dev/nvme0n1p << EOF
  p
  g
  y
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

mkfs.ext4 /dev/nvme0n1p3
mkfs.fat -F 32 /dev/nvme0n1p1
mkswap /dev/nvme0n1p2

mount /dev/nvme0n1p3 /mnt
mount --mkdir /dev/nvme0n1p1 /mnt/boot
swapon /dev/nvme0n1p2

pacstrap -K /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt << EOF
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
  grub-install --tartget=x86_64-efi --efi-directory=/boot/eif -- bootloader-id=GRUB --removable
  grub-mkconfig -o /boot/grub/grub.cfg
  exit
EOF

umount -R /mnt
