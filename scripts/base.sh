#----------------------------------------------------------------
# TODO base
archchroot(){
	echo "arch-chroot /mnt /root"
	cp ${0} /mnt/root
	chmod 755 /mnt/root/$(basename "${0}")
	arch-chroot /mnt /root/$(basename "${0}") --chroot ${1} ${2}
	rm /mnt/root/$(basename "${0}")
	echo "exit"
}


rebootpc(){
	if (whiptail --backtitle "${apptitle}" --title "${txtreboot}" --yesno "${txtreboot} ?" --defaultno 0 0) then
		clear
		echo reboot
		reboot
	fi
}

settimedate() {
	clear
	timedatectl set-ntp true 
	hwclock --systohc
	timedatectl status
	pressanykey
}

setsourcelist() {
	clear
	echo "Server = https://mirrors.bfsu.edu.cn/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist
	pacman -Syy
	cat /etc/pacman.d/mirrorlist
	pressanykey
}

selectdisk(){
		items=$(lsblk -d -p -n -l -o NAME,SIZE -e 7,11)
		options=()
		IFS_ORIG=$IFS
		IFS=$'\n'
		for item in ${items}
		do  
				options+=("${item}" "")
		done
		IFS=$IFS_ORIG
		result=$(whiptail --backtitle "${APPTITLE}" --title "${1}" --menu "" 0 0 0 "${options[@]}" 3>&1 1>&2 2>&3)
		if [ "$?" != "0" ]
		then
				return 1
		fi
		echo ${result%%\ *}
		return 0    
}



diskpartcgdisk(){
		device=$( selectdisk "${txteditparts} (cgdisk)" )
	if [ "$?" = "0" ]; then
		clear
		cgdisk ${device}
	fi
}

selectparts(){
	items=$(lsblk -p -n -l -o NAME -e 7,11)
	options=()
	for item in ${items}; do
		options+=("${item}" "")
	done

	bootdev=$(whiptail --backtitle "${apptitle}" --title "${txtselectpartsmenu}" --menu "${txtselectdevice//%1/boot}" --default-item "${bootdev}" 0 0 0 \
		"none" "-" \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ ! "$?" = "0" ]; then
		return 1
	else
		if [ "${bootdev}" = "none" ]; then
			bootdev=
		fi
	fi

	swapdev=$(whiptail --backtitle "${apptitle}" --title "${txtselectpartsmenu}" --menu "${txtselectdevice//%1/swap}" --default-item "${swapdev}" 0 0 0 \
		"none" "-" \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ ! "$?" = "0" ]; then
		return 1
	else
		if [ "${swapdev}" = "none" ]; then
			swapdev=
		fi
	fi

	rootdev=$(whiptail --backtitle "${apptitle}" --title "${txtselectpartsmenu}" --menu "${txtselectdevice//%1/root}" --default-item "${rootdev}" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ ! "$?" = "0" ]; then
		return 1
	fi
	realrootdev=${rootdev}

	homedev=$(whiptail --backtitle "${apptitle}" --title "${txtselectpartsmenu}" --menu "${txtselectdevice//%1/home}" 0 0 0 \
		"none" "-" \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ ! "$?" = "0" ]; then
		return 1
	else
		if [ "${homedev}" = "none" ]; then
			homedev=
		fi
	fi

	msg="${txtselecteddevices}\n\n"
	msg=${msg}"boot : "${bootdev}"\n"
	msg=${msg}"swap : "${swapdev}"\n"
	msg=${msg}"root : "${rootdev}"\n"
	msg=${msg}"home : "${homedev}"\n\n"
	if (whiptail --backtitle "${apptitle}" --title "${txtselectpartsmenu}" --yesno "${msg}" 0 0) then
		isnvme=0
		if [ "${bootdev::8}" == "/dev/nvm" ]; then
			isnvme=1
		fi
		if [ "${rootdev::8}" == "/dev/nvm" ]; then
			isnvme=1
		fi
		mountmenu
	fi
}

mountmenu(){
	if [ "${1}" = "" ]; then
		nextitem="."
	else
		nextitem=${1}
	fi
	options=()
	options+=("${txtformatdevices}" "")
	options+=("${txtmount}" "${txtmountdesc}")
	sel=$(whiptail --backtitle "${apptitle}" --title "${txtformatmountmenu}" --menu "" --cancel-button "${txtback}" --default-item "${nextitem}" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ "$?" = "0" ]; then
		case ${sel} in
			"${txtformatdevices}")
				formatdevices
				nextitem="${txtmount}"
			;;
			"${txtmount}")
				mountparts
				nextitem="${txtmount}"
			;;
		esac
		mountmenu "${nextitem}"
	fi
}


unmountdevices(){
	clear
	echo "umount -R /mnt"
	umount -R /mnt
	if [ ! "${swapdev}" = "" ]; then
		echo "swapoff ${swapdev}"
		swapoff ${swapdev}
	fi
	lsblk
	pressanykey
}
# -

formatdevices(){
	if (whiptail --backtitle "${apptitle}" --title "${txtformatdevices}" --yesno "${txtformatdeviceconfirm}" --defaultno 0 0) then
		fspkgs=""
		if [ ! "${bootdev}" = "" ]; then
			formatbootdevice boot ${bootdev}
		fi
		if [ ! "${swapdev}" = "" ]; then
			formatswapdevice swap ${swapdev}
		fi
		formatdevice root ${rootdev}
		if [ ! "${homedev}" = "" ]; then
			formatdevice home ${homedev}
		fi
	fi
}
formatbootdevice(){
	options=()
	if [ "${efimode}" == "1" ]||[ "${efimode}" = "2" ]; then
		options+=("fat32" "(EFI)")
	fi
	options+=("ext2" "")
	options+=("ext3" "")
	options+=("ext4" "")
	if [ ! "${efimode}" = "1" ]&&[ ! "${efimode}" = "2" ]; then
		options+=("fat32" "(EFI)")
	fi
	sel=$(whiptail --backtitle "${apptitle}" --title "${txtformatdevice}" --menu "${txtselectpartformat//%1/${1} (${2})}" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ ! "$?" = "0" ]; then
		return 1
	fi
	clear
	echo "${txtformatingpart//%1/${2}} ${sel}"
	echo "----------------------------------------------"
	case ${sel} in
		ext2)
			echo "mkfs.ext2 ${2}"
			mkfs.ext2 ${2}
		;;
		ext3)
			echo "mkfs.ext3 ${2}"
			mkfs.ext3 ${2}
		;;
		ext4)
			echo "mkfs.ext4 ${2}"
			mkfs.ext4 ${2}
		;;
		fat32)
			fspkgs="${fspkgs[@]} dosfstools"
			echo "mkfs.fat ${2}"
			mkfs.fat ${2}
		;;
	esac
	echo ""
	pressanykey
}
formatswapdevice(){
	options=()
	options+=("swap" "")
	sel=$(whiptail --backtitle "${apptitle}" --title "${txtformatdevice}" --menu "${txtselectpartformat//%1/${1} (${2})}" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ ! "$?" = "0" ]; then
		return 1
	fi
	clear
	echo "${txtformatingpart//%1/${swapdev}} swap"
	echo "----------------------------------------------------"
	case ${sel} in
		swap)
			echo "mkswap ${swapdev}"
			mkswap ${swapdev}
			echo ""
			pressanykey
		;;
	esac
	clear
}
formatdevice(){
	options=()
	options+=("btrfs" "")
	options+=("ext4" "")
	options+=("ext3" "")
	options+=("ext2" "")
	options+=("xfs" "")
	options+=("f2fs" "")
	options+=("jfs" "")
	options+=("reiserfs" "")
	if [ ! "${3}" = "noluks" ]; then
		options+=("luks" "encrypted")
	fi
	sel=$(whiptail --backtitle "${apptitle}" --title "${txtformatdevice}" --menu "${txtselectpartformat//%1/${1} (${2})}" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ ! "$?" = "0" ]; then
		return 1
	fi
	clear
	echo "${txtformatingpart//%1/${2}} ${sel}"
	echo "----------------------------------------------"
	case ${sel} in
		btrfs)
			fspkgs="${fspkgs[@]} btrfs-progs"
			echo "mkfs.btrfs -f ${2}"
			mkfs.btrfs -f ${2}
			if [ "${1}" = "root" ]; then
				echo "mount ${2} /mnt"
				echo "btrfs subvolume create /mnt/root"
				echo "btrfs subvolume set-default /mnt/root"
				echo "umount /mnt"
				mount ${2} /mnt
				btrfs subvolume create /mnt/root
				btrfs subvolume set-default /mnt/root
				umount /mnt/boot/efi
				umount /mnt
			fi
		;;
		ext4)
			echo "mkfs.ext4 ${2}"
			mkfs.ext4 ${2}
		;;
		ext3)
			echo "mkfs.ext3 ${2}"
			mkfs.ext3 ${2}
		;;
		ext2)
			echo "mkfs.ext2 ${2}"
			mkfs.ext2 ${2}
		;;
		xfs)
			fspkgs="${fspkgs[@]} xfsprogs"
			echo "mkfs.xfs -f ${2}"
			mkfs.xfs -f ${2}
		;;
		f2fs)
			fspkgs="${fspkgs[@]} f2fs-tools"
			echo "mkfs.f2fs -f $2"
			mkfs.f2fs -f $2
		;;
		jfs)
			fspkgs="${fspkgs[@]} jfsutils"
			echo "mkfs.jfs -f ${2}"
			mkfs.jfs -f ${2}
		;;
		reiserfs)
			fspkgs="${fspkgs[@]} reiserfsprogs"
			echo "mkfs.reiserfs -f ${2}"
			mkfs.reiserfs -f ${2}
		;;
		luks)
			echo "${txtcreateluksdevice}"
			echo "cryptsetup luksFormat ${2}"
			cryptsetup luksFormat ${2}
			if [ ! "$?" = "0" ]; then
				pressanykey
				return 1
			fi
			pressanykey
			echo ""
			echo "${txtopenluksdevice}"
			echo "cryptsetup luksOpen ${2} ${1}"
			cryptsetup luksOpen ${2} ${1}
			if [ ! "$?" = "0" ]; then
				pressanykey
				return 1
			fi
			pressanykey
			options=()
			options+=("normal" "")
			options+=("fast" "")
			sel=$(whiptail --backtitle "${apptitle}" --title "${txtformatdevice}" --menu "Wipe device ?" --cancel-button="${txtignore}" 0 0 0 \
				"${options[@]}" \
				3>&1 1>&2 2>&3)
			if [ "$?" = "0" ]; then
				case ${sel} in
					normal)
						echo "dd if=/dev/zero of=/dev/mapper/${1}"
						dd if=/dev/zero of=/dev/mapper/${1} & PID=$! &>/dev/null
					;;
					fast)
						echo "dd if=/dev/zero of=/dev/mapper/${1} bs=60M"
						dd if=/dev/zero of=/dev/mapper/${1} bs=60M & PID=$! &>/dev/null
					;;
				esac
				clear
				sleep 1
				while kill -USR1 ${PID} &>/dev/null
				do
					sleep 1
				done
			fi
			echo ""
			pressanykey
			formatdevice ${1} /dev/mapper/${1} noluks
			if [ "${1}" = "root" ]; then
				realrootdev=${rootdev}
				rootdev=/dev/mapper/${1}
				luksroot=1
				luksrootuuid=$(cryptsetup luksUUID ${2})
			else
				case ${1} in
					home) homedev=/dev/mapper/${1} ;;
				esac
				luksdrive=1
				crypttab="\n${1}    UUID=$(cryptsetup luksUUID ${2})    none"
			fi
			echo ""
			echo "${txtluksdevicecreated}"
		;;
	esac
	echo ""
	pressanykey
}

mountparts(){
	clear
	echo "mount ${rootdev} /mnt"
	mount ${rootdev} /mnt
	echo "mkdir /mnt/{boot,home}"
	mkdir /mnt/{boot,home} 2>/dev/null
	mkdir /mnt/boot/efi 2>/dev/null
	if [ ! "${bootdev}" = "" ]; then
		echo "mount ${bootdev} /mnt/boot/efi"
		mount ${bootdev} /mnt/boot/efi
	fi
	if [ ! "${swapdev}" = "" ]; then
		echo "swapon ${swapdev}"
		swapon ${swapdev}
	fi
	if [ ! "${homedev}" = "" ]; then
		echo "mount ${homedev} /mnt/home"
		mount ${homedev} /mnt/home
	fi
	pressanykey
	installmenu
}

selectmirrorsbycountry() {
		if [[ ! -f /etc/pacman.d/mirrorlist.backup ]]; then
				cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
		fi    

		options=()
		IFS_ORIG=$IFS
		IFS=$'\n'
	
		options+=("China" "")
		
		IFS=$IFS_ORIG
		country=$(whiptail --backtitle "${APPTITLE}" --title "${txtselectcountry}" --menu "" 0 0 0 "${options[@]}" 3>&1 1>&2 2>&3)
		if [ "$?" != "0" ]; then
				return 1    
		fi

		clear
		tip "Reflector..."
		reflector --country $country --age 24 --sort rate --protocol https --save /etc/pacman.d/mirrorlist
		pressanykey
}


installbase(){
	
	options=()
	options+=("base" ")" on)
	options+=("base-devel" ")" on)
	options+=("linux" "" on)
	options+=("linux-headers" ")" on)
	options+=("amd-ucode" ")" on)
	options+=("neovim" ")" on)
	options+=("git" ")" on)	

	sel=$(whiptail --backtitle "${apptitle}" --title "${txtinstallarchlinuxfilesystems}" --checklist "" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ ! "$?" = "0" ]; then
		return 1
	fi
	for itm in $sel; do
		pkgs="$pkgs $(echo $itm | sed 's/"//g')"
	done
		
	clear
	echo "pacstrap /mnt ${pkgs}"
	pacstrap /mnt ${pkgs}
	pressanykey
}

archgenfstab() {
	clear
	tip "gen fstab"
	genfstab -U /mnt > /mnt/etc/fstab

	cat /mnt/etc/fstab
	pressanykey
}




#TODO base end--------------------------------------------------------
