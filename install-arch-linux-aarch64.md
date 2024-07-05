# Make partition on SSD
```
fdisk /dev/nvme0n1
```
# At the fdisk prompt, delete old partitions and create a new one:

    Type o. This will clear out any partitions on the drive.
    Type p to list partitions. There should be no partitions left.
    Type n, then p for primary, 1 for the first partition on the drive, press ENTER to accept the default first sector, then type +200M for the last sector.
    Type t, then c to set the first partition to type W95 FAT32 (LBA).
    Type n, then p for primary, 2 for the second partition on the drive, and then press ENTER twice to accept the default first and last sector.
    Write the partition table and exit by typing w.

# Create and mount the FAT filesystem:
```
mkfs.vfat /dev/nvme0n1p1
```
```
mkdir boot
```
```
mount /dev/nvme0n1p1 boot
```
# Create and mount the ext4 filesystem:
```
mkfs.ext4 /dev/nvme0n1p2
```
```
mkdir root
```
```
mount /dev/nvme0n1p2 root
```
# Download and extract Arch Linux ARM image
```
mkdir /mnt
```
```
cd /mnt
```
```
wget http://os.archlinuxarm.org/os/ArchLinuxARM-aarch64-latest.tar.gz
```
```
bsdtar -xpf ArchLinuxARM-aarch64-latest.tar.gz -C root
```
```
sync
```
# Mount necessary filesystems
```
mount --rbind /dev dev
mount --make-rslave dev
mount -t proc /proc proc
mount --rbind /sys sys
mount --make-rslave sys
mount --rbind /tmp tmp
```
# Move and copy necessary files
```
cp /etc/resolv.conf etc
```
```
mv root/boot/* boot
```
# Chroot into the new system
```
arch-chroot root /bin/bash
```

# Initialize pacman keys and update package database
```
pacman-key --init
pacman-key --populate archlinuxarm
pacman -Syuuu
```
# Install necessary packages
```
pacman -S openssh vim sudo base-devel libnewt git
```
# Set root password
```
passwd
```
# Configure SSH
```
vim /etc/ssh/sshd_config
```
# Create a new user (optional)
```
useradd -m -G wheel your_user
```
```
passwd your_user
```
```
EDITOR=vim visudo  # Uncomment the %wheel ALL=(ALL) ALL line
```
# Set keymap
```
loadkeys de_CH-latin1
```
# Set time and timezone
```
timedatectl set-timezone Europe/Zurich
```
```
hwclock --systohc
```
# Edit locale.gen
```
vim locale-gen
```
```
LANG=de_DE.UTF-8
```
# Set hostname
```
hostnamectl set-hostname LX2162a
```
# Configure network (example for Ethernet)
```
ip link
```
```
systemctl enable dhcpcd@eth0
```
# Enable SSH service
```
systemctl enable sshd
```
# Exit chroot and reboot
```
exit
```
```
umount -R /mnt
```
```
reboot
```
