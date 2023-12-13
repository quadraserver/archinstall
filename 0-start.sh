#!/bin/bash

## Prerequisites // Enter here your personal preferences
loadkey de-latin1
setfont ter-120b

##Title
clear
echo ""
echo "---------------------------------------------------------------------"
echo ""
echo "            _             _       ___           _        _ _ "
echo "           / \   _ __ ___| |__   |_ _|_ __  ___| |_ __ _| | |"
echo "          / _ \ | '__/ __| '_ \   | || '_ \/ __| __/ _' | | |"
echo "         / ___ \| | | (__| | | |  | || | | \__ \ || (_| | | |"
echo "        /_/   \_\_|  \___|_| |_| |___|_| |_|___/\__\__,_|_|_|"
echo ""
echo "---------------------------------------------------------------------"
echo "             Welcome to the MODIFIED Arch Install Script"
echo "                          2023 Thomas Lange"
echo "---------------------------------------------------------------------"
echo "      This script is about to install Arch Linux on ONE drive"
echo "                     with the following options:"
echo "---------------------------------------------------------------------"
echo "  - EFI  Drive   --> VFAT - for GRUB and/or external Bootloaders"
echo "    recommendation: Type: ef00, Size: 200MiB"
echo "  - BOOT Drive   --> EXT4 - for your Kernel / Grub / Plymouth stuff" 
echo "    recommendation: Type: 8300, Size: rest of drive"
echo "  - ROOT Drive   --> LVM Encrypted BTRFS Volume" 
echo "    recommendation: Type: 8300, Size: rest of drive"
echo "---------------------------------------------------------------------"
echo "  This is STAGE 0."
echo "---------------------------------------------------------------------"
echo ""
echo "These are your drives:"
echo ""
lsblk
echo ""

## Question
read -p "  What is your drive? (eg. sda): " drive
echo ""
echo "  thank you."
echo ""
while true; do
    echo "  Do you need to partition your drive?"
    echo "--------------------------------------------"
    echo "  Answering [Yy] will open cfdisk for you,"
    echo "  answer with [Nn], if your drive"
    read -p "  is already partitioned" yn
    case $yn in
        [Yy]* ) cfdisk /dev/$drive; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

pacman-key --init
pacman-key --populate archlinux
pacman -Sy
pacman -S archlinux-keyring git
cd /root
git clone https://www.github.com/quadraserver/archinstall.git
cd archinstall
./1-install.sh
