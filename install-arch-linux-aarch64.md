# Install btrfs-progs
sudo apt install btrfs-progs

# Create Btrfs filesystem and mount it
mkfs.btrfs /dev/nvme0n1p1
mount /dev/nvme0n1p1 /mnt

# Download and extract Arch Linux ARM image
cd /mnt
wget http://os.archlinuxarm.org/os/ArchLinuxARM-aarch64-latest.tar.gz
bsdtar -xpf ArchLinuxARM-aarch64-latest.tar.gz

# Mount necessary filesystems
mount --rbind /dev dev
mount --make-rslave dev
mount -t proc /proc proc
mount --rbind /sys sys
mount --make-rslave sys
mount --rbind /tmp tmp
cp /etc/resolv.conf etc

# Chroot into the new system
chroot . /bin/bash
source /etc/profile

# Initialize pacman keys and update package database
pacman-key --init
pacman-key --populate archlinuxarm
pacman -Syu

# Install necessary packages
pacman -S openssh vim sudo

# Set root password
passwd

# Configure SSH
vim /etc/ssh/sshd_config

# Create a new user (optional)
useradd -m -G wheel your_user
passwd your_user
EDITOR=vim visudo  # Uncomment the %wheel ALL=(ALL) ALL line

# Configure network (example for Ethernet)
ip link
systemctl enable dhcpcd@eth0

# Enable SSH service
systemctl enable sshd

# Exit chroot and reboot
exit
umount -R /mnt
reboot
