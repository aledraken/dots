#!/usr/bin/env bash

DEVICE=$(hostnamectl chassis)

if mountpoint -q /mnt; then
	echo "/mnt already mounted"
	exit
fi

# Disk selection

lsblk -n

read -p "Choose a disk: " DISK

if [ ! -b /dev/$DISK ]; then
	echo "$DISK is missing"
	exit
fi

# Verify if device is correct

if [ $DEVICE == "vm" ]; then
	echo "In a vm"
elif [ $DEVICE == "laptop" ]; then
	echo "In a laptop"
else
	echo "In a desktop"
fi

read -p "Is this correct? (Y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^(""|[yY])$ ]]; then
	echo -e "1. VM\n2. Laptop\n3. Desktop"
	read -p "Choose a device: "
	echo ${REPLY,,}
	if [[ $REPLY =~ ^("vm"|"1")$ ]]; then
		DEVICE="vm"
	elif [[ $REPLY =~ ^("laptop"|"2")$ ]]; then
		DEVICE="laptop"
	else
		DEVICE="desktop"
	fi
	
	echo "Device is now $DEVICE"
fi

# Ensure everything is correct before installing

echo -e "\nTODO\n"
echo "Partition disk /dev/$DISK"
echo "Device type $DEVICE"
echo

read -p "Is everything correct, continue installation? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^([yY])$ ]]; then
	echo Exiting install script
	exit
fi

# PARTITIONING

PARTED="parted /dev/$DISK -s -f -a optimal --"

$PARTED mklabel gpt
$PARTED mkpart ESP fat32 0% 1G
$PARTED set 1 esp on
$PARTED mkpart root ext4 1G 100%

# #TODO
# In the vm lsblk sometimes doesn't display newly created partitions
DISKPARTITIONS=$(lsblk -lno NAME /dev/$DISK)
mapfile PARTITIONS < <(echo "$DISKPARTITIONS")
mkfs.fat -F 32 -n boot /dev/${PARTITIONS[1]}
mkfs.ext4 -F -L arch /dev/${PARTITIONS[2]}

mount /dev/${PARTITIONS[2]} /mnt
mount --mkdir /dev/${PARTITIONS[1]} /mnt/boot

# PACKAGES

# vconsole.conf
# to avoid an error during install
mkdir -p /mnt/etc
echo "KEYMAP=us" > /mnt/etc/vconsole.conf
echo "Created /mnt/etc/vconsole.conf"

PACKAGES="base linux"

if [ $DEVICE != "vm" ]; then
	PACKAGES="${PACKAGES} linux-firmware intel-ucode"
fi

if [ $DEVICE == "laptop" ]; then
	PACKAGES="${PACKAGES} iwd"
fi

pacstrap -K /mnt $PACKAGES

# CHROOT
CHROOT="arch-chroot /mnt"

# Network

if [ $DEVICE == "laptop" ]; then
	$CHROOT systemctl enable iwd systemd-resolved
	echo -e "[General]\nEnableNetworkConnfiguration=true\n[Network]\nEnableIPv6=false\nNameResolvingService=systemd" > /etc/iwd/main.conf
fi

# Fstab
genfstab -U /mnt >> /mnt/etc/fstab

# TIME & ZONE
$CHROOT ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime
$CHROOT hwclock --systohc

# Locales
echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf
sed -i '/#en_US.UTF-8 UTF-8/s/^#//g' /mnt/etc/locale.gen
$CHROOT locale-gen

# HOSTNAME
echo "a-linux-$DEVICE" > /mnt/etc/hostname

# Pacman
sed -i '/#Color/c\Color\nILoveCandy' /etc/pacman.conf
sed -i '/#VerbosePkgLists/s/^#//g' /etc/pacman.conf

# BOOTLOADER
$CHROOT bootctl install
echo -e "default @saved\ntimeout 3\nconsole-mode max" > /mnt/boot/loader/loader.conf
PARTUUID=$(blkid -s PARTUUID -o value /dev/${PARTITIONS[2]})

if [ $DEVICE == "vm" ]; then
	echo -e "title Arch Linux\nlinux /vmlinuz-linux\ninitrd /initramfs-linux.img\noptions root=PARTUUID=$PARTUUID zswap.enabled=0 rw rootfstype=ext4" > /mnt/boot/loader/entries/arch.conf
else
	echo -e "title Arch Linux\nlinux /vmlinuz-linux\ninitrd /intel-ucode.img\ninitrd /initramfs-linux.img\noptions root=PARTUUID=$PARTUUID zswap.enabled=0 rw rootfstype=ext4" > /mnt/boot/loader/entries/arch.conf
fi

# USERS

echo "Create root password"
$CHROOT passwd

read -p "Create user account? (Y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^(""|[yY])$ ]]; then
	read -p "Username: " USERNAME
	$CHROOT useradd -m "$USERNAME"
	$CHROOT usermod -aG wheel "$USERNAME"
	$CHROOT passwd "$USERNAME"
	$CHROOT pacman -S --noconfirm sudo
	mkdir -p /mnt/etc/sudoers.d
	echo "%wheel ALL=(ALL) ALL" > /mnt/etc/sudoers.d/99_wheel
fi


