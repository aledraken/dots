#!/usr/bin/env bash

# https://github.com/aledraken/dots
# Install script version:
# 0.12

set -e

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
NC="\e[0m"

mapfile -d " " boot_opts < <(echo "systemd-boot uki")

# Check boot entries

boot_entries_count=$(efibootmgr | grep -c "A-Linux" || true)

if [ "$boot_entries_count" -gt 0 ]; then
	echo -e "${RED}Previous boot entries found!$NC"
	while (( $boot_entries_count > 0 )); do
		echo -e "$YELLOW$boot_entries_count entries remaining$NC"
		efibootmgr | tail -n +4
		
		read -p "Choose an entry: (xxxx) " entry_to_delete
		
		#entry_to_delete=$(echo "$entry_to_delete" | xargs)
		
		
		read -p "Are you sure? (y/N) " -n 1 reply
		echo
		if [[ "$reply" != [yY] ]]; then
			echo
			continue
		fi
		
		efibootmgr -b "$entry_to_delete" -B >/dev/null

		boot_entries_count=$(efibootmgr | grep -c "A-Linux" || true)

		echo
	done
	echo -e "${GREEN}All duplicate entries were deleted!$NC\n"
fi

# Unmount /mnt
if mountpoint -q /mnt; then
	umount -R /mnt
fi

# Check internet connection
if ! ping -c 1 9.9.9.9 > /dev/null; then
	systemctl start iwd
	while true; do
		iwctl 

		if ping -c 1 9.9.9.9 > /dev/null; then
			break
		fi
	done
fi

#############
# ARGUMENTS #
#############

while [[ $# -gt 0 ]]; do
	case "$1" in
		-h|--help)
			echo -e "
-h|--help - Show this dialog
-um|--updatemirrors - Updates mirrors with reflector
-u|-n|--name - Set username
-up|--userpass - Set user password
-p|--rootpass - Set root password
Either set a disk or the 2 partitions
-d|--disk - Set install disk
-bp|--bootpart - Set boot partition
-rp|--rootpart - Set root partition
-de|--device - Either: desktop laptop vm
-vm|--vmtype - Currently supports oracle only
-b|--boot - Either: systemd-boot uki 
"
			exit 0
			;;
		-um|--updatemirrors)
			#TODO get region? or ask and get neighboring regions?
			reflector --country Italy,Germany,France,Albania,Spain,Switzerland,Austria --sort rate --latest 10 --save /etc/pacman.d/mirrorlist
			cat /etc/pacman.d/mirrorlist
			exit 0
			;;
		-u|-n|--name)
			username="$2"
			shift
			;;
		-up|--userpass)
			user_password="$2"
			shift
			;;
		-p|--rootpass)
			root_password="$2"
			shift
			;;
		-d|--disk)
			disk="$2"
			shift
			;;
		-bp|--bootpart)
			boot_partition="$2"
			efi_partition="$2"
			disk=$(lsblk -no pkname /dev/$efi_partition)
			shift
			;;
		-rp|--rootpart)
			root_partition="$2"
			shift
			;;
		-de|--device)
			device="$2"
			shift
			;;
		-vm|--vmtype)
			vm_type="$2"
			shift
			;;
		-b|--boot)
			boot="$2"
			shift
			;;

		-*|--*)
			echo "Unknown option $1"
			exit 1
			;;
		*)
			shift
			;;
	esac
	shift
done

###################
# CHECK FUNCTIONS #
###################

part_check() {
	if [[ ! -n "$boot_partition" || ! -n "$root_partition" ]]; then
		return 1
	fi

	if [[ "$boot_partition" == "$root_partition" ]]; then
		echo -e "$RED$boot_partition and $root_partition are the same$NC"
		return 1
	fi

	if [ ! -b "/dev/$root_partition" ]; then
		echo -e "$RED$root_partition does not exist!$NC"
		return 1
	else
		if [ $(lsblk -no TYPE "/dev/$root_partition" | head -n 1) != "part" ]; then
			echo -e "$RED$root_partition is not a partition!$NC"
			return 1
		fi
	fi

	if [ ! -b "/dev/$boot_partition" ]; then
		echo "$RED$boot_partition does not exist!$NC"
		return 1
	else
		if [ $(lsblk -no TYPE "/dev/$boot_partition" | head -n 1) != "part" ]; then
			echo -e "$RED$boot_partition is not a partition!$NC"
			return 1
		fi
	fi
}

disk_check() {
	if [[ ! -n "$disk" ]]; then
		return 1
	fi

	if [ ! -b "/dev/$disk" ]; then
		echo -e "$RED$disk does not exist!$NC"
		return 1
	else
		if [ $(lsblk -ndo TYPE "/dev/$disk") != "disk" ]; then
			echo -e "$RED$disk is not a disk!$NC"
			return 1
		fi
	fi
}

boot_check() {
	found=false

	for i in ${boot_opts[@]}; do
		if [[ "$i" == "$boot" ]]; then
		found=true
		fi
	done

	if ! $found; then
	    return 1
	fi
}

#################
# SET FUNCTIONS #
#################

select_disk() {
	mapfile DISKS < <(lsblk -dno NAME | grep -v sr | grep -v loop)

	while true;
	do
		for index in ${!DISKS[@]}; do
			printf "$index = ${DISKS[$index]}"
		done

		read -p "Choose a disk: " disk

		if [[ "$disk" =~ ^[0-9]+$ ]]; then
			disk="${DISKS[$disk]}"
		fi

		disk="$(echo $disk | xargs)"

		if disk_check; then
			break
		fi

		echo
	done
}

set_username() {
	while true;
	do
		read -p "Choose a username: " username

		username="$(echo $username | xargs)"

		if [ ! -n "$username" ]; then
			echo -e "${RED}Username is empty!$NC"
			continue
		fi

		read -p "Is this correct? Y/n " confirm

		if [[ "$confirm" == [yY] || -z "$confirm" ]]; then
			echo -e "${GREEN}Username set!$NC"
			break
		fi
	done
}

set_user_password() {
	while true;
	do
		read -sp "Enter user password: " pass1
		echo
		read -sp "Confirm password: " pass2
		echo

		if [ "$pass1" == "$pass2" ]; then
			user_password=$pass1
			echo -e "${GREEN}User password set!$NC"
			break
		else
			echo -e "${RED}Password mismatch!$NC"
		fi
	done
}

set_root_password() {
	while true;
	do
		read -sp "Enter root password: " pass1
		echo
		read -sp "Confirm password: " pass2
		echo

		if [ "$pass1" == "$pass2" ]; then
			root_password=$pass1
			echo -e "${GREEN}Root password set!$NC"
			break
		else
			echo -e "${RED}Password mismatch!$NC"
		fi
	done
}

set_vm() {
	#TODO currently only useful for oracle virtualbox
	vm=$(systemd-detect-virt)
}

set_cpu() {
	#TODO I added grep -oE so it stops if there something other than Intel
	# but if I ever get an amd processor I should add that too
	cpu=$(lscpu | grep "Vendor ID" | awk '{print $NF}' | grep -oE 'GenuineIntel')
}

set_gpu() {
	#TODO same as cpu but besides amd gpus also other virtual machines
	gpu=$(lspci | grep "VGA" | grep -oE 'NVIDIA|Intel|VMware')
}

set_device() {
	device=$(hostnamectl chassis)
}

set_boot() {
	while true;
	do
		for index in ${!boot_opts[@]}; do
			echo "$index = ${boot_opts[$index]}" | xargs
		done

		read -p "Choose a boot option: " boot
		
		if [[ "$boot" =~ ^[0-9]+$ ]]; then
			boot="${boot_opts[$boot]}"
		fi

		boot="$(echo $boot | xargs)"
		
		if boot_check; then
			break
		else
			echo -e "$RED$boot doesn't exist$NC"
			echo
		fi
	done
}

######################
# PRELIMINARY CHECKS #
######################


if ! boot_check; then
	set_boot
	echo -e "${GREEN}Boot selected: $boot$NC\n"
fi

if ! part_check || ! disk_check; then
	root_partition=""
	efi_partition=""
	boot_partition=""
	select_disk
	echo -e "${GREEN}Disk selected: $disk$NC"
fi

echo

if [[ ! -n "$username" ]]; then
	set_username
	echo
fi

if [[ ! -n "$user_password" ]]; then
	set_user_password
	echo
fi

if [[ ! -n "$root_password" ]]; then
	set_root_password
	echo
fi

if [[ ! -n "$device" ]]; then
	set_device
fi

if [[ ! -n "$vm" && "$device" == "vm" ]]; then
	set_vm
fi

if [[ ! -n "$gpu" ]]; then
	set_gpu
fi

if [[ ! -n "$cpu" ]]; then
	set_cpu
fi

trim=false
disks=$(lsblk -dno NAME | grep -v sr | grep -v loop)
for d in $disks; do
	disc_max=$(lsblk --discard -dno DISC-MAX /dev/$d)
	if [ $disc_max != "0B" ]; then
		trim=true
		break
	fi
done


# CONFIRM DIALOG

echo -e "Root password: $root_password
Username: $username | Password: $user_password"

echo "Boot: $boot"

echo "Disk: /dev/$disk"
if [ -n "$root_partition" ]; then
	echo -e "Partitions:
	BOOT: /dev/$boot_partition
	ROOT: /dev/$root_partition"
fi

echo "Trim: $trim"

if [ "$device" == "vm" ]; then
	echo "Device: $device | $vm"
else
	echo "Device: $device"
	echo "CPU: $cpu | GPU: $gpu"
fi

echo
read -p "Is everything correct? (y/N) " -n 1 -r
echo
if [[ ! "$REPLY" == [yY] || -z "$REPLY" ]]; then
	exit 0
fi

###################
# SETUP FUNCTIONS #
###################

CHROOT="arch-chroot /mnt"

format_disk() {
	sgdisk -I --zap-all /dev/$disk
	sgdisk -I -n 1:0:+1G -t 1:ef00 /dev/$disk
	sgdisk -I -n 2:0:0 -t 2:8300 /dev/$disk
	
	mapfile partitions < <(lsblk -lno NAME /dev/$disk)

	if [[ "$boot" == "uki" ]]; then
		efi_partition=${partitions[1]}
		efi_partition=$(echo "$efi_partition" | xargs)
	else
		boot_partition=${partitions[1]}
		boot_partition=$(echo "$boot_partition" | xargs)
	fi
	root_partition=${partitions[2]}
	root_partition=$(echo "$root_partition" | xargs)
}

format_partitions() {
	if [[ "$boot" == "uki" ]]; then
		mkfs.fat -F 32 -n ESP /dev/$efi_partition
	else
		mkfs.fat -F 32 -n BOOT /dev/$boot_partition
	fi
	mkfs.ext4 -F -L ARCH /dev/$root_partition
}

mount_partitions() {
	mount /dev/$root_partition /mnt
	if [[ "$boot" == "uki" ]]; then
		mount --mkdir /dev/$efi_partition /mnt/efi
	else
		mount --mkdir /dev/$boot_partition /mnt/boot
	fi
}

install_packages() {
	packages="sudo zram-generator neovim networkmanager"


	if [[ "$device" == "vm" ]]; then
		case "$vm" in
			"oracle")
				packages="$packages linux-headers virtualbox-guest-utils"
				;;
		esac

	else
		drivers="linux-firmware"
		case "$cpu" in
			"GenuineIntel")
				drivers="$drivers intel-ucode"
				;;
		esac

		case "$gpu" in
			"NVIDIA")
				drivers="$drivers nvidia-open nvidia-settings libva-nvidia-driver"
				;;
			"Intel")
				drivers="$drivers mesa vulkan-intel intel-media-driver libvpl vpl-gpu-rt"
				;;
		esac
	fi

	echo -e "${YELLOW}Installing base packages$NC"
	
	pacstrap -K /mnt base linux

	echo -e "${YELLOW}Installing utility packages$NC"

	pacstrap /mnt $packages

	echo -e "${YELLOW}Installing drivers$NC"
	
	pacstrap /mnt $drivers
}

setup_zram-generator() {
	echo -e "[zram0]
compression-algorithm = zstd" > /mnt/etc/systemd/zram-generator.conf
	echo -e "vm.swappiness = 180
vm.watermark_boost_factor = 0
vm.watermark_scale_factor = 125
vm.page-cluster = 0" > /mnt/etc/sysctl.d/99-vm-zram-parameters.conf
}

set_mkinitcpio() {
	if [ $device != "vm" ]; then
		case "$gpu" in
			"NVIDIA")
				sed -i '/MODULES=()/c\MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)' /mnt/etc/mkinitcpio.conf
				mkinitcpio -P
				;;
		esac
	fi
}

set_environment_variables() {
	if [ "$device" == "vm" ]; then
		echo "WLR_NO_HARDWARE_CURSORS=1" >> /mnt/etc/environment
	else
		case "$gpu" in
			"NVIDIA")
				echo -e "LIBVA_DRIVER_NAME=nvidia\n__GLX_VENDOR_LIBRARY_NAME=nvidia\nNVD_BACKEND=direct\nVDPAU_DRIVER=nvidia" >> /mnt/etc/environment;;
			"Intel")
				echo -e "LIBVA_DRIVER_NAME=iHD\nANV_DEBUG=video-decode,video-encode" >> /mnt/etc/environment;;
		esac
	fi
	echo "ELECTRON_OZONE_PLATFORM_HINT=auto" >> /mnt/etc/environment
}

chroot_setup() {
	# VM
	if [ "$device" == "vm" ]; then
		case "$vm" in
			"oracle")
				$CHROOT systemctl enable vboxservice;;
		esac
	fi

	# TRIM
	if [ $trim == true ]; then
		$CHROOT systemctl enable fstrim.timer
	fi

	# HOSTNAME
	echo "a-linux-$device" > /mnt/etc/hostname

	# NETWORK
	$CHROOT systemctl enable NetworkManager
	$CHROOT systemctl enable systemd-resolved
	ln -sf ../run/systemd/resolve/stub-resolv.conf /mnt/etc/resolv.conf
	DNS="9.9.9.9#dns.quad9.net 149.112.112.112#dns.quad9.net 2620:fe::fe#dns.quad9.net 2620:fe::9#dns.quad9.net"
	sed -i "/#DNS=/c\DNS=$DNS" /mnt/etc/systemd/resolved.conf
	sed -i '/#DNSSEC=no/c\Color\n#DNSSEC=yes' /mnt/etc/pacman.conf
	sed -i '/#DNSOverTLS=no/c\Color\n#DNSOverTLS=yes' /mnt/etc/pacman.conf

	# TIME & ZONE
	$CHROOT ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime
	$CHROOT hwclock --systohc
	$CHROOT systemctl enable systemd-timesyncd

	# LOCALES
	echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf
	sed -i '/#en_US.UTF-8 UTF-8/s/^#//g' /mnt/etc/locale.gen
	$CHROOT locale-gen
}

systemd-boot_setup() {
	$CHROOT bootctl install
	echo -e "default @saved
timeout 3
console-mode max" > /mnt/boot/loader/loader.conf
	part_uuid=$(blkid -s PARTUUID -o value /dev/$root_partition)

	echo -e "title Arch Linux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options root=PARTUUID=$part_uuid" > /mnt/boot/loader/entries/arch.conf

	if [ "$device" != "vm" ]; then
		case "$cpu" in
			"GenuineIntel")
				sed -i '\|linux /vmlinuz-linux|a\initrd /intel-ucode.img' /mnt/boot/loader/entries/arch.conf
				;;
		esac
	fi
}

uki_setup() {
	mkdir -p /mnt/etc/cmdline.d
	part_uuid=$(blkid -s PARTUUID -o value /dev/$root_partition)
	echo "root=PARTUUID=$part_uuid rw" >> /mnt/etc/cmdline.d/root.conf

	sed -i '/^#default_uki/s/^#//' /mnt/etc/mkinitcpio.d/linux.preset
	sed -i '/^#default_options/s/^#//' /mnt/etc/mkinitcpio.d/linux.preset

	mkdir -p /mnt/efi/EFI/Linux
	$CHROOT mkinitcpio -p linux
	partition_number=$(cat "/sys/class/block/$efi_partition/partition")
	efibootmgr --create --disk /dev/$disk --part $partition_number --label "A-Linux" --loader '\EFI\Linux\arch-linux.efi' --unicode
}

sudo_setup() {
	# Enable sudo for users in group wheel
	echo "%wheel ALL=(ALL:ALL) ALL" > /mnt/etc/sudoers.d/99_wheel
	# Allows running programs like gufw and firewall-config in wayland
	echo 'Defaults env_keep += "XDG_RUNTIME_DIR"
	Defaults env_keep += "WAYLAND_DISPLAY"' > /mnt/etc/sudoers.d/wayland
}

users_setup() {
	$CHROOT useradd -m "$username"
	$CHROOT usermod -aG wheel "$username"
	
	if [ "$device" == "vm" ]; then
		case "$vm" in
			"oracle")
				$CHROOT usermod -aG vboxsf "$username"
				mkdir -p /mnt/media
				$CHROOT chown -R $username:users /media
				;;
		esac
	fi

	echo "root:$root_password" | chpasswd -R /mnt
	echo "$username:$user_password" | chpasswd -R /mnt
}

##################
# INSTALL SYSTEM #
##################

# DISK & PARTITIONS
echo -e "${YELLOW}FORMATTING DISK$NC"
if [[ -n "$disk" && -z "$root_partition" ]]; then
	format_disk
fi

echo -e "${YELLOW}FORMATTING PARTITIONS$NC"
format_partitions
mount_partitions

# VCONSOLE
mkdir -p /mnt/etc
echo "KEYMAP=us" > /mnt/etc/vconsole.conf

# PACKAGES
echo -e "${YELLOW}INSTALLING PACKAGES$NC"
install_packages

# SWAP / ZRAM
setup_zram-generator

# MKINITCPIO
set_mkinitcpio

# ENVIRONMENT VARIABLES
set_environment_variables

# FSTAB
echo -e "${YELLOW}GENERATING FSTAB$NC"
genfstab -U /mnt >> /mnt/etc/fstab

# PACMAN
sed -i '/#Color/c\Color\nILoveCandy' /mnt/etc/pacman.conf
sed -i '/#VerbosePkgLists/s/^#//g' /mnt/etc/pacman.conf

# CHROOT
chroot_setup

# BOOTLOADER
echo -e "${YELLOW}INSTALLING BOOTLOADER$NC"
case "$boot" in
	"systemd-boot")
		systemd-boot_setup
		;;
	"uki")
		uki_setup
		;;
esac

# SUDO
echo -e "${YELLOW}SETTING UP SUDO$NC"
sudo_setup

# USERS
echo -e "${YELLOW}SETTING UP USERS$NC"
users_setup

echo -e "${GREEN}SETUP CONCLUDED$NC"

exit 0
