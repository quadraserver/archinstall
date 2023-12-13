# Archinstall Script (LUKS and BTRFS)
Here is my arch installation script for my personal use. 

This sets up an Arch Linux System as described below.

For the time being, the System uses an GPT partition scheme with:
  - one EFI partition (VFAT), 
  - one boot partition (EXT4) and
  - one encrypted (LUKS) ROOT Filesystem (BTRFS) <br> with snapshots and timeshift

For now I dont't feel the need of a LVM-Setup (Logical Volume Manager), <br> since I use the BTRFS-filesystem on the root partition for the same result.
