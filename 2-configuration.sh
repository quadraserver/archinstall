#!/bin/bash
#   ____             __ _                       _   _             
#  / ___|___  _ __  / _(_) __ _ _   _ _ __ __ _| |_(_) ___  _ __  
# | |   / _ \| '_ \| |_| |/ _` | | | | '__/ _` | __| |/ _ \| '_ \ 
# | |__| (_) | | | |  _| | (_| | |_| | | | (_| | |_| | (_) | | | |
#  \____\___/|_| |_|_| |_|\__, |\__,_|_|  \__,_|\__|_|\___/|_| |_|
#                         |___/                                   
# ------------------------------------------------------
packan-key --init
pacman-key --populate
pacman -Syy
pacman -S archlinux-keyring
clear
read -p "Please enter your desired keyboard (i.e. de-latin1): " keyboardlayout
echo ""
read -p "Please enter your timezone (i.e. /Europe/Berlin): " zoneinfo
echo ""
read -p "Please enter the hostname of your machine: " hostname
echo ""
read -p "Please enter your desired username: " username
# ------------------------------------------------------
# Set System Time
# ------------------------------------------------------
ln -sf /usr/share/zoneinfo/$zoneinfo /etc/localtime
# ------------------------------------------------------
# Update reflector
# ------------------------------------------------------
echo "Starting reflector... (this can take a while)"
reflector -c "Germany," -p https -a 3 --sort rate --save /etc/pacman.d/mirrorlist
# ------------------------------------------------------
# Synchronize mirrors
# ------------------------------------------------------
pacman -Syy
# ------------------------------------------------------
# Install Packages
# ------------------------------------------------------
pacman --noconfirm -S linux-headers efibootmgr dosfstools gptfdisk ntfs-3g os-prober grub-btrfs networkmanager iwd network-manager-applet nm-connection-editor firefox firefox-i18n-de acpid acpi acpi_call dbus dialog wpa_supplicant mtools avahi nfs-utils inetutils dnsmasq openbsd-netcat ipset firewalld flatpak sof-firmware dnsutils xdg-desktop-portal-wlr xdg-user-dirs xdg-utils gvfs gvfs-smb bluez bluez-utils cups hplip alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack bash-completion terminus-font htop neofetch mc zip unzip xarchiver p7zip nss-mdns exa bat duf xorg xorg-xinit xclip xf86-video-amdgpu xf86-video-nouveau xf86-video-intel xf86-video-qxl brightnessctl pacman-contrib inxi lvm2 wget git gcc ruby go xorg-server mpc mpd mpv cmatrix asciiquarium notepadqq thunar thunar-archive-plugin pavucontrol lxappearance qt5ct xfce4 xfce4-goodies alacritty kitty foot gum sddm qt5-quickcontrols2 qt5-graphicaleffects swayfx polybar rofi picom feh nitrogen thunar thunar-archive-plugin xarchiver zip unzip p7zip lxappearance pcmanfm asciiquarium cmatrix mc neofetch htop btop vim neovim
# ------------------------------------------------------
# set language to de_DE.UTF-8
# ------------------------------------------------------
echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=de_DE.UTF-8" >> /etc/locale.conf
# ------------------------------------------------------
# Set Keyboard and font for personal preference
# ------------------------------------------------------
echo "KEYMAP=$keyboardlayout" >> /etc/vconsole.conf
echo "FONT=ter-122b" >> /etc/vconsole.conf
# ------------------------------------------------------
# Set hostname and localhost
# ------------------------------------------------------
echo "$hostname" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 $hostname.localdomain $hostname" >> /etc/hosts
clear
# ------------------------------------------------------
# Set Root Password
# ------------------------------------------------------
echo "Set root password"
passwd root
# ------------------------------------------------------
# Add User
# ------------------------------------------------------
echo "Add user $username"
useradd -m -g users -G wheel,audio,video,games,power -s /bin/bash $username
passwd $username
# ------------------------------------------------------
# Enable Services
# ------------------------------------------------------
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable sshd
systemctl enable avahi-daemon
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable firewalld
systemctl enable acpid
# ------------------------------------------------------
# Grub installation
# ------------------------------------------------------
echo "Installing Grub."
echo ""
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id="Arch Linux" --recheck
grub-mkconfig -o /boot/grub/grub.cfg
# ------------------------------------------------------
# Add btrfs and setfont to mkinitcpio
# ------------------------------------------------------
# Before: BINARIES=()
# After:  BINARIES=(btrfs setfont)
sed -i 's/BINARIES=()/BINARIES=(btrfs setfont)/g' /etc/mkinitcpio.conf
mkinitcpio -p linux
# ------------------------------------------------------
# Add user to wheel
# ------------------------------------------------------
clear
echo "Uncomment %wheel group in sudoers (around line 85):"
echo "Before: #%wheel ALL=(ALL:ALL) ALL"
echo "After:  %wheel ALL=(ALL:ALL) ALL"
echo ""
read -p "Open sudoers now?" c
EDITOR=nano sudo -E visudo
clear
#echo
#echo "Creating sddm.conf in /etc"
#echo
#sddm --example-config >> /etc/sddm.conf
#echo "Done."
#echo "Downloading and copying "
#echo "sugar-candy theme to /usr/share/sddm/themes"
#git clone https://www.github.com/quadraserver/sddm.git
#cd sddm
#chmod +x install-theme.sh
#./install-theme.sh
#cd ..
#echo 
#echo "Done."
#echo
#echo " Please change theme in sddm.conf to "
#echo " -->sugar-candy<-- and save it!"
#nano /etc/sddm.conf
#echo
#echo "Done."
#echo
#echo "Activating sddm on next reboot now..."
#systemctl enable sddm
# ------------------------------------------------------
# Copy installation scripts to home directory 
# ------------------------------------------------------
mkdir -p /home/$username/scripts
cp /archinstall/3-yay.sh /home/$username/scripts
cp /archinstall/4-zram.sh /home/$username/scripts
cp /archinstall/5-timeshift.sh /home/$username/scripts
cp /archinstall/6-preload.sh /home/$username/scripts
cp /archinstall/7-kvm.sh /home/$username/scripts
cp /archinstall/snapshot.sh /home/$username/scripts
cp /archinstall/snapshot.sh /home/$username
chown -R $username /home/$username/scripts
# ------------------------------------------------------
# Clear archinstall directory in / 
# ------------------------------------------------------
rm -R /archinstall
clear
echo ""
echo "Done."
echo ""
echo "You can find the following scripts in the scripts-directory of your home folder:"
echo "- yay: 3-yay.sh"
echo "- zram swap: 4-zram.sh"
echo "- timeshift snapshot tool: 5-timeshift.sh"
echo "- preload application cache: 6-preload.sh"
#echo "- KVM-virtualisation script: 7-kvm.sh"
echo "- snapshot.sh"
echo ""
echo "Please reboot."
echo ""
echo "Have fun."
