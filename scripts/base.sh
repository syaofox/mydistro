
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
		# reboot
	fi
}

settimedate() {
	clear
	timedatectl set-ntp true 

	etip "timedatectl status"
}

setsourcelist() {
	clear
	echo "Server = https://mirrors.bfsu.edu.cn/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist
	pacman -Syy
	etip "cat /etc/pacman.d/mirrorlist"
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