#!/bin/bash

## Title
clear
echo ""
echo "    _             _       ___           _        _ _ "
echo "   / \   _ __ ___| |__   |_ _|_ __  ___| |_ __ _| | |"
echo "  / _ \ | '__/ __| '_ \   | || '_ \/ __| __/ _' | | |"
echo " / ___ \| | | (__| | | |  | || | | \__ \ || (_| | | |"
echo "/_/   \_\_|  \___|_| |_| |___|_| |_|___/\__\__,_|_|_|"
echo ""
echo "-----------------------------------------------------"
echo " STAGE 1 - First of all, without encrypting, for testing ..."
echo "-----------------------------------------------------"
echo ""
echo "These are your drives:"
echo ""
lsblk
# ------------------------------------------------------
# Enter partition names
# ------------------------------------------------------
read -p "Enter the name of the EFI partition (eg. sda1): " efidrive
read -p "Enter the name of the BOOT partition (eg. sda2): " bootdrive
read -p "Enter the name of the ROOT partition (eg. sda3): " rootdrive

# ------------------------------------------------------
# Sync time
# ------------------------------------------------------
timedatectl set-ntp true

# ------------------------------------------------------
# Format partitions
# ------------------------------------------------------
mkfs.vfat -F 32 /dev/$efidrive
mkfs.ext4 /dev/$bootdrive

mkfs.btrfs -f /dev/$rootdrive

# ------------------------------------------------------
# Mount points for btrfs
# ------------------------------------------------------
mount /dev/$rootdrive /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@cache
btrfs su cr /mnt/@home
btrfs su cr /mnt/@snapshots
btrfs su cr /mnt/@log
mkdir -p /mnt/@/archinstall
mkdir -p /mnt/@/media/{Windows,Daten,Spiele,Installation,Backup}
umount /mnt

mount -o compress=zstd:1,noatime,subvol=@ /dev/$rootdrive /mnt

mkdir -p /mnt/{boot/efi,home,.snapshots,var/{cache,log}}

mount -o subvol=@ /dev/$bootdrive /mnt/boot
mount -o subvol=@ /dev/$efidrive /mnt/boot/efi

mount -o compress=zstd:1,noatime,subvol=@cache /dev/$rootdrive /mnt/var/cache
mount -o compress=zstd:1,noatime,subvol=@home /dev/$rootdrive /mnt/home
mount -o compress=zstd:1,noatime,subvol=@log /dev/$rootdrive /mnt/var/log
mount -o compress=zstd:1,noatime,subvol=@snapshots /dev/$rootdrive /mnt/.snapshots

# ------------------------------------------------------
# Install base packages
# ------------------------------------------------------
pacstrap -K /mnt base base-devel linux linux-firmware dhcpcd nano git openssh reflector rsync intel-ucode

# ------------------------------------------------------
# Generate fstab
# ------------------------------------------------------
genfstab -U /mnt >> /mnt/etc/fstab

echo "This is your fstab:"
echo ""
cat /mnt/etc/fstab

# ------------------------------------------------------
# Install configuration scripts
# ------------------------------------------------------
cp 2-configuration.sh /mnt/archinstall/
cp 3-yay.sh /mnt/archinstall/
cp 4-zram.sh /mnt/archinstall/
cp 5-timeshift.sh /mnt/archinstall/
cp 6-preload.sh /mnt/archinstall/
cp 7-kvm.sh /mnt/archinstall
cp snapshot.sh /mnt/archinstall/

# ------------------------------------------------------
# Chroot to installed sytem
# ------------------------------------------------------
arch-chroot /mnt ./archinstall/2-configuration.sh

