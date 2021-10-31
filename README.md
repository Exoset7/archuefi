FFACI by eugene for Exo
Fucking French Archlinux Custom Install

Before continuing : read this example for prepare the disk
he following partitions are required with gpt mode  ( use cfdisk tools for that)
              /dev/sdaXXXXXX1     150M       type :  EFI System
              /dev/sdaXXXXXX2     500G       type :  Linux FileSystem

 Format the partitions
 - mkfs.vfat /dev/sdaXXXXXX1
 - mkfs.ext4 /dev/sdaXXXXXX2

 Mount the root partition file systems
 - mount /dev/sdaXXXXXX1 /mnt
 
 Create directory for boot/efi
 - mkdir -p /mnt/boot/efi
 - 
 Mount the boot/efi partition
- mount /dev/sdaXXXXXX2 /mnt/boot/efi
- 
- sudo pacman -Sy

- sudo pacman -S git

- git clone https://github.com/Exoset7/archuefi.git

- cd archuefi

- chmod +x archuefi.sh

- ./archuefi.sh
