# archinstall (LUKS and BTRFS)
Here is my arch installation script for my personal use. This sets up an Arch Linux System as described below.

For the time being, the System uses an GPT partition scheme with one EFI partition (VFAT), one boot partition (EXT4)
and an encrypted (LUKS) ROOT Filesystem (BTRFS) with snapshots and timeshift.

For now I dont't feel the need ov LVM (Logical Volume Manager), since I use the BTRFS for the same results.
