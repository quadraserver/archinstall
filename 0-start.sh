#!/bin/bash

## Prerequisites // Enter here your personal preferences
loadkey de-latin1
setfont ter-120b

##Title
clear
echo ""
echo "            _             _       ___           _        _ _ "
echo "           / \   _ __ ___| |__   |_ _|_ __  ___| |_ __ _| | |"
echo "          / _ \ | '__/ __| '_ \   | || '_ \/ __| __/ _' | | |"
echo "         / ___ \| | | (__| | | |  | || | | \__ \ || (_| | | |"
echo "        /_/   \_\_|  \___|_| |_| |___|_| |_|___/\__\__,_|_|_|"
echo ""
echo "                 Welcome to the Arch Install Script"
echo "                          2023 Thomas Lange"
echo ""
echo "---------------------------------------------------------------------"
echo "  This is STAGE 0."
echo "---------------------------------------------------------------------"
echo ""
echo "This script is about to install Arch Linux with LUKS and BTRFS"
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
    read -p "  is already partitioned. " yn
    case $yn in
        [Yy]* ) cfdisk /dev/$drive; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no. [Yy/Nn] ";;
    esac
done
pacman-key --init
pacman-key --populate archlinux
pacman -Syy
pacman -Sy archlinux-keyring git
cd /root
git clone https://www.github.com/quadraserver/archinstall.git
cd /root/archinstall
./1-install.sh
