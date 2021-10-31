#!/bin/sh
#
# FFACI by eugene
# Fucking French Archlinux Custom Install
#
# Before continuing : read this example for prepare the disk
#    - The following partitions are required with gpt mode  ( you can use cfdisk tools for that)
#               /dev/sdaXXXXXX1     150M       type :  EFI System
#               /dev/sdaXXXXXX2     500G       type :  Linux FileSystem
#
#    - Format the partitions
#               mkfs.vfat /dev/sdaXXXXXX1
#               mkfs.ext4 /dev/sdaXXXXXX2
#
#    - Mount the root partition file systems
#               mount /dev/sdaXXXXXX1 /mnt
#    - Create directory for boot/efi
#               mkdir -p /mnt/boot/efi
#    - Mount the boot/efi partition
#               mount /dev/sdaXXXXXX2 /mnt/boot/efi
#

# Ask Username
echo "enter the username : "
read username

# Update the system clock
timedatectl set-ntp true

# you need to config manually harddisk
# Partition the disk       (manually)
# Format the partitions    (manually)
# Mount the file systems   (manually)

# Select the mirros
echo "Server = http://archlinux.mirrors.ovh.net/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist
echo "Server = http://ftp.u-strasbg.fr/linux/distributions/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist
echo "Server = http://ftp-stud.hs-esslingen.de/pub/Mirrors/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist

# Install essential packages
pacstrap /mnt base linux linux-firmware grub nano intel-ucode efibootmgr

# Generate an fstab with UUID
genfstab -U /mnt >> /mnt/etc/fstab

# Change root into the new system
#arch-chroot /mnt

# Set the time zone
arch-chroot /mnt bash -c "ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime"

# Localization
sed -i "s|#fr_FR.UTF-8 UTF-8|fr_FR.UTF-8 UTF-8|g" /mnt/etc/locale.gen
arch-chroot /mnt bash -c "locale-gen"

# Create locale.conf and set the LANG variable
arch-chroot /mnt bash -c "echo 'LANG=fr_FR.UTF-8' >> /etc/locale.conf"

# Create vconsole.conf and set keyboard layout
arch-chroot /mnt bash -c "echo 'KEYMAP=fr' >> /etc/vconsole.conf"

# Create the hostname file
#arch-chroot /mnt bash -c "echo 'eugene' >> /etc/hostname"
arch-chroot /mnt bash -c "echo $username >> /etc/hostname"


# Create hosts file
arch-chroot /mnt bash -c "echo '127.0.0.1     localhost $username' >> /etc/hosts"
arch-chroot /mnt bash -c "echo '::1           localhost $username' >> /etc/hosts"

# Define root password
echo "Define root password"
arch-chroot /mnt bash -c "passwd"

# Install grub
arch-chroot /mnt bash -c "grub-install --target=x86_64-efi --bootloader-id=ArchDev --efi-directory=/boot/efi"
arch-chroot /mnt bash -c "grub-mkconfig -o /boot/grub/grub.cfg"


# Define French Keyboard for X
#arch-chroot /mnt bash -c "localectl set-x11-keymap fr"
arch-chroot /mnt bash -c "mkdir --parent /etc/X11/xorg.conf.d"
arch-chroot /mnt bash -c "echo 'Section \"InputClass\"' > /etc/X11/xorg.conf.d/00-keyboard.conf"
arch-chroot /mnt bash -c "echo '    Identifier \"system-keyboard\"' >> /etc/X11/xorg.conf.d/00-keyboard.conf"
arch-chroot /mnt bash -c "echo '    MatchIsKeyboard \"on\"' >> /etc/X11/xorg.conf.d/00-keyboard.conf"
arch-chroot /mnt bash -c "echo '    Option \"XkbLayout\" \"fr\"' >> /etc/X11/xorg.conf.d/00-keyboard.conf"
arch-chroot /mnt bash -c "echo 'EndSection' >> /etc/X11/xorg.conf.d/00-keyboard.conf"

# Create New user and define password
arch-chroot /mnt bash -c "useradd -m $username"
echo "Define user password"
arch-chroot /mnt bash -c "passwd $username"

# Install Packages like  Xorg,  video driver,  Desktop .....
arch-chroot /mnt bash -c "pacman -S base-devel \
                                    xorg-server \
                                    xf86-input-synaptics \
                                    linux-headers \
                                    nano \
                                    netctl \
                                    networkmanager \
                                    sudo \
                                    dialog \
                                    plasma-desktop \
                                    plasma-nm \
                                    plasma-pa \
                                    powerdevil \
                                    bluedevil \
                                    dolphin \
                                    konsole \
                                    kate \
                                    kscreen \
                                    sddm \
                                    sddm-kcm"

# Enable Systemd NetworkManager
arch-chroot /mnt bash -c "systemctl enable NetworkManager.service"

# Enable Systemd SDDM
arch-chroot /mnt bash -c "systemctl enable sddm"
umount -R /mnt/boot/efi
umount -R /mnt
reboot

