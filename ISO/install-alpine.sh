#!/bin/sh

# This script will be run inside the Alpine live environment
# to install a base system to the main disk.

# Set up networking (Alpine live usually does this automatically)
# But we'll ensure it's ready
ip link set eth0 up
udhcpc -i eth0

# Partition the main disk
# Assuming the main disk is /dev/sda
echo "Partitioning /dev/sda..."
fdisk /dev/sda <<EOF
o
n
p
1

+512M
n
p
2


a
1
w
EOF

# Format the partitions
echo "Formatting partitions..."
mkfs.ext4 /dev/sda2
mkswap /dev/sda1
swapon /dev/sda1

# Mount the root partition
echo "Mounting root partition..."
mount /dev/sda2 /mnt

# Install base system
echo "Installing base system..."
setup-disk -m sys /mnt

# Chroot and configure
echo "Configuring system..."
mount --bind /dev /mnt/dev
mount --bind /proc /mnt/proc
mount --bind /sys /mnt/sys

chroot /mnt /bin/sh <<'CHROOT_EOF'
# Set root password
echo "root:agentpassword" | chpasswd

# Install and enable SSH
apk add openssh
rc-update add sshd default

# Create agentuser
adduser -D -s /bin/sh agentuser
echo "agentuser:agentpassword" | chpasswd
adduser agentuser wheel

# Allow wheel group to sudo (install sudo first)
apk add sudo
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

# Configure network (basic DHCP)
echo "auto eth0" > /etc/network/interfaces
echo "iface eth0 inet dhcp" >> /etc/network/interfaces

# Set hostname
echo "agent-vm" > /etc/hostname
CHROOT_EOF

# Unmount
umount /mnt/sys
umount /mnt/proc
umount /mnt/dev
umount /mnt

echo "Installation complete. You can now boot from the main disk."