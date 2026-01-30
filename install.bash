#!/usr/bin/env bash

# Can be vm, desktop, laptop
DEVICE=$(hostnamectl chassis)

if mountpoint -q /mnt; then
	echo "/mnt already mounted"
	echo "Trying to unmount /mnt"
	umount -R /mnt
	exit
fi

# Disk Selection

DISKSEL=false
mapfile DISKS < <(lsblk -dno NAME | grep -v sr)

while ! $DISKSEL
do
	for index in ${!DISKS[@]}; do
		printf "$index = ${DISKS[$index]}"
	done
	MAXDISKS=$((${#DISKS[@]} - 1))

	read -p "Choose a disk: " DISK

	
	if [[ $DISK =~ ^[0-$MAXDISKS]+$ ]]; then
		DISK=${DISKS[$DISK]}
		echo Selected $DISK
	fi

	if [ ! -b /dev/$DISK ]; then
		echo "$DISK does not exist"
		continue
	fi

	DISKSEL=true
done	

echo $DISK does exist, continuing...

# USER

RPSET=false
while ! $RPSET
do
	read -p "Type Root Password: " ROOTPASSWD
	read -p "Retype Root Password: " ROOTPASSWD2
	if [ $ROOTPASSWD != $ROOTPASSWD2 ]; then
		echo "Password mismatch"
		continue
	fi

	RPSET=true
done


USERNAMESET=false
while ! $USERNAMESET
do
	read -p "Username: " USERNAME
	read -p "Are you sure your name is "$USERNAME"? (Y/n) " -n 1 -r
	echo
	if ! [[ $REPLY =~ ^(""|[yY])$ ]]; then
		continue
	fi
	
	USERNAMESET=true
done

UPSET=false
while ! $UPSET
do
	read -p "Type $USERNAME Password: " USERPASSWD
	read -p "Retype $USERNAME Password: " USERPASSWD2
	if [ $USERPASSWD != $USERPASSWD2 ]; then
		echo "Password mismatch"
		continue
	fi

	UPSET=true
done

# MIRRORS
reflector --latest 5 --sort rate --save /etc/pacman.d/mirrorlist

#

echo
echo "Disk to partition: /dev/$DISK"
echo "Device type: $DEVICE"
echo "Is everything correct?"
echo "Username: $USERNAME"
echo "Mirrors:"
cat /etc/pacman.d/mirrorlist
echo

read -p "Continue installation? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^([yY])$ ]]; then
	echo Exiting
	exit
fi


# INSTALLATION

# PARTITIONING

PARTED="parted /dev/$DISK -s -f -a optimal --"
$PARTED mklabel gpt
$PARTED mkpart ESP fat32 0% 1G
$PARTED set 1 esp on
$PARTED mkpart root ext4 1G 100%

DISKPARTITIONS=$(lsblk -lno NAME /dev/$DISK)
mapfile PARTITIONS < <(echo "$DISKPARTITIONS")
mkfs.fat -F 32 -n boot /dev/${PARTITIONS[1]}
mkfs.ext4 -F -L arch /dev/${PARTITIONS[2]}

mount /dev/${PARTITIONS[2]} /mnt
mount --mkdir /dev/${PARTITIONS[1]} /mnt/boot

# CONSOLE KEYBOARD LAYOUT
mkdir -p /mnt/etc
echo "KEYMAP=us" > /mnt/etc/vconsole.conf

# PACKAGES

PACKAGES="base linux sudo"

case $DEVICE in
	"vm")
		PACKAGES="$PACKAGES linux-headers virtualbox-guest-utils"
		;;
	*)
		PACKAGES="$PACKAGES linux-firmware intel-ucode"
		if [ $DEVICE == "laptop" ]; then
			PACKAGES="$PACKAGES iwd"
		fi
		;;
esac

pacstrap -K /mnt $PACKAGES

# CHROOT

CHROOT="arch-chroot /mnt"

# VM

if [ $DEVICE == "vm" ]; then
	$CHROOT systemctl enable vboxservice
fi

# TRIM (SSD)
DISCARD=$(lsblk -d $DISK --discard -lno DISC-MAX)
if ! [ $DISCARD == "0B" ]; then
        $CHROOT systemctl enable fstrim.timer
        echo "Enabled trim timer"
fi

# NETWORK
case $DEVICE in
	"laptop")
		$CHROOT systemctl enable iwd
		mkdir -p /mnt/etc/iwd
		echo -e "[General]\nEnableNetworkConnfiguration=true\n[Network]\nEnableIPv6=false\nNameResolvingService=systemd" > /mnt/etc/iwd/main.conf
		;;
	*)
		$CHROOT systemctl enable systemd-networkd
		cp /mnt/usr/lib/systemd/network/89-ethernet.network.example /mnt/etc/systemd/network/89-ethernet.network
esac

$CHROOT systemctl enable systemd-resolved
ln -sf ../run/systemd/resolve/stub-resolv.conf /mnt/etc/resolv.conf
DNS="9.9.9.9#dns.quad9.net 149.112.112.112#dns.quad9.net 2620:fe::fe#dns.quad9.net 2620:fe::9#dns.quad9.net"
sed -i "/#DNS=/c\DNS=$DNS" /mnt/etc/systemd/resolved.conf

# AUTO MOUNT
genfstab -U /mnt >> /mnt/etc/fstab

# TIME & ZONE
$CHROOT ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime
$CHROOT hwclock --systohc

# LOCALES
echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf
sed -i '/#en_US.UTF-8 UTF-8/s/^#//g' /mnt/etc/locale.gen
$CHROOT locale-gen

# HOSTNAME
echo "a-linux-$DEVICE" > /mnt/etc/hostname

# PACMAN
sed -i '/#Color/c\Color\nILoveCandy' /mnt/etc/pacman.conf
sed -i '/#VerbosePkgLists/s/^#//g' /mnt/etc/pacman.conf

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
$CHROOT useradd -m "$USERNAME"
$CHROOT usermod -aG wheel "$USERNAME"

if [ $DEVICE == "vm" ]; then
	$CHROOT usermod -aG vboxsf "$USERNAME"
	mkdir -p /mnt/media
	$CHROOT chown -R $USERNAME:users /media/
fi

echo "root:$ROOTPASSWD" | chpasswd -R /mnt
echo "$USERNAME:$USERPASSWD" | chpasswd -R /mnt

mkdir -p /mnt/etc/sudoers.d
echo "%wheel ALL=(ALL) ALL" > /mnt/etc/sudoers.d/99_wheel
