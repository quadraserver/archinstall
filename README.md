# Arch Linux install script (LUKS and BTRFS)
Here is my arch installation script for my personal use. 

This sets up an Arch Linux System as described below.

For the time being, the System uses an GPT partition scheme with:
  - one EFI partition (VFAT), 
  - one boot partition (EXT4) and
  - one encrypted (LUKS) ROOT Filesystem (BTRFS) <br> with snapshots and timeshift

For now I dont't feel the need of a LVM-Setup (Logical Volume Manager), <br> since I use the BTRFS-filesystem on the root partition for the same result.

The script is a shell script, meant to be used from the offical Arch ISO.  <br>  

It makes heavily use of the bash toolkit "gum" for nice text-effects <br> 
and graphical selection-buttons. The script will take care of this itself.

# Prerequisites:
1.) set up your keyboard locale ("loadkeys de-latin1" in my case), <br>
2.) change the fontsize to somewhat more readable with ("setfont ter-120b")<br> 
3.) connect to the internet, as described here: 
    https://wiki.archlinux.org/title/Network_configuration/Wireless  <br> 
    however, in most cases with a wired connection, the internet simply works. :-)
    You ca test it by the command: ("ping -c3 www.archlinux.org"), for examplee.
4.) initialise the pacman keys with the following commands:
    ("pacman-key --init") and ("pacman-key --populate archlinux") <br> 
5.) Install "git" by typing: ("pacman -Sy && pacman -S git")
6.) clone the repo by doing the following:
    ("cd") and )"git clone https://www.github.com/quadraserver/archinstall.git")
    enter the repo with ("cd archinstall") and start the scritp with: <br> 
    ./archinstall.sh

Thats it.
