#!/usr/bin/bash
set -e

# Archlinux Installation Script for VMs
# ebal, Wed 21 Aug 2019

#Disk=sda # VirtualBox
Disk=vda # Qemu/KVM

echo ',,,*;' | sfdisk /dev/$Disk

mkdir -pv /mnt/$Disk
mkfs.ext4 -v -L rootfs /dev/${Disk}1
mount /dev/${Disk}1 /mnt/$Disk

pacman -Syy

pacstrap /mnt/$Disk base
genfstab -U /mnt/$Disk >> /mnt/$Disk/etc/fstab

# Install Grub
cat > /mnt/$Disk/root/grub.sh <<EOF
pacman -S --noconfirm grub vim
grub-install /dev/$Disk
grub-mkconfig -o /boot/grub/grub.cfg
# Add Swap Partition
dd if=/dev/zero of=/swapfile bs=2048 count=1048576
mkswap /swapfile -L swapfs
chmod 0600 /swapfile
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
EOF

chmod +x /mnt/$Disk/root/grub.sh

arch-chroot /mnt/vda/ /root/grub.sh

reboot
