
txtmainmenu="Main Menu"

txtsetdatetime="Set timedate"
txtdiskpartmenu="Disk Partitions"
txteditparts="Edit Partitions"
txtselectpartsmenu="Select Partitions and Install"
txtselectdevice="Select %1 device :"


txtformatdevices="Format Devices"
txtformatboot="Format boot"
txtformatswap="Format swap"
txtformatroot="Format root"
txtformathome="Format home"

txtmountdesc="Install or Config"
txtmount="Mount"
txtunmount="Unmount"
txtformatdeviceconfirm="Warning, all data on selected devices will be erased ! \nFormat devices ?"

txtselectmirrorsbycountry="Select mirrors by country"
txteditmirrorlist="Edit mirrorlist"

txtinstallarchlinux="Install Arch Linux"
txtgenfstab="Gen fstab"
txtswitchtochroot="Settingh arch-chroot"

txtreboot="Reboot"

mainmenu() {
    if [ "${1}" = "" ]; then
		nextitem="."
	else
		nextitem=${1}
	fi
	options=()
	options+=("${txtsetdatetime}" "")	
	options+=("${txtdiskpartmenu}" "")	
	options+=("${txtselectpartsmenu}" "")	
    options+=("${txtformatdevices}" "")
	options+=("${txtmount}" "${txtmountdesc}")
	

	options+=("" "")
	options+=("${txtreboot}" "")
	sel=$(whiptail --backtitle "${apptitle}" --title "${txtmainmenu}" --menu "" --cancel-button "${txtexit}" --default-item "${nextitem}" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ "$?" = "0" ]; then
		case ${sel} in
			"${txtsetdatetime}")
				settimedate
				nextitem="${txtdiskpartmenu}"
			;;
			"${txtdiskpartmenu}")
				diskpartcgdisk
				nextitem="${txtselectpartsmenu}"
			;;
			"${txtselectpartsmenu}")
				selectparts
				nextitem="${txtformatdevices}"
			;;
			"${txtformatdevices}")
				format_devices
				nextitem="${txtmount}"
			;;
			"${txtmount}")
				mountparts
				nextitem="${txtselectmirrorsbycountry}"
				mainmenu2 "${nextitem}"
			;;
			"${txtreboot}")				
				rebootpc
				nextitem="${txtreboot}"
			;;
		esac
		mainmenu "${nextitem}"
	else
		clear
	fi
}


mainmenu2() {
    if [ "${1}" = "" ]; then
		nextitem="."
	else
		nextitem=${1}
	fi
	options=()
	options+=("${txtsetdatetime}" "")	
	options+=("${txtdiskpartmenu}" "")	
	options+=("${txtselectpartsmenu}" "")	
    options+=("${txtformatdevices}" "")
	options+=("${txtmount}" "${txtmountdesc}")
	options+=("${txtselectmirrorsbycountry}" "(${txtoptional})")
	options+=("${txteditmirrorlist}" "(${txtoptional})")
	options+=("${txtinstallarchlinux}" "")
	options+=("${txtgenfstab}" "")
	options+=("${txtswitchtochroot}" "")

	options+=("" "")
	options+=("${txtreboot}" "")
	sel=$(whiptail --backtitle "${apptitle}" --title "${txtmainmenu}" --menu "" --cancel-button "${txtexit}" --default-item "${nextitem}" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ "$?" = "0" ]; then
		case ${sel} in
			"${txtsetdatetime}")
				settimedate
				nextitem="${txtdiskpartmenu}"
			;;
			"${txtdiskpartmenu}")
				diskpartcgdisk
				nextitem="${txtselectpartsmenu}"
			;;
			"${txtselectpartsmenu}")
				selectparts
				nextitem="${txtformatdevices}"
			;;
			"${txtformatdevices}")
				format_devices
				nextitem="${txtmount}"
			;;
			"${txtmount}")
				mountparts
				nextitem="${txtselectmirrorsbycountry}"
			;;
			"${txtselectmirrorsbycountry}")
				selectmirrorsbycountry
				nextitem="${txteditmirrorlist}"
			;;
			"${txteditmirrorlist}")
				${EDITOR} /etc/pacman.d/mirrorlist
				pacman -Syy
				nextitem="${txtinstallarchlinux}"
			;;

			"${txtinstallarchlinux}")
				if(installbase) then
					nextitem="${txtgenfstab}"
				fi
			;;
			"${txtgenfstab}")
				archgenfstab
				nextitem="${txtswitchtochroot}"
			;;
			"${txtswitchtochroot}")
				switchtochroot
				nextitem="${txtsethostname}"
			;;			

			"${txtreboot}")				
				rebootpc
				nextitem="${txtreboot}"
			;;
		esac
		mainmenu2 "${nextitem}"
	else
		exit
	fi
}

settimedate() {
	clear
	timedatectl set-ntp true 
	timedatectl status
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
		
	fi
}

format_devices(){
    if [ "${1}" = "" ]; then
		nextitem="."
	else
		nextitem=${1}
	fi

	options=()
	options+=("${txtformatboot}" "${bootdev}")	
	options+=("${txtformatswap}" "${swapdev}")	
	options+=("${txtformatroot}" "${rootdev}")	
    options+=("${txtformathome}" "${homedev}")	
	sel=$(whiptail --backtitle "${apptitle}" --title "${txtformatdevices}" --menu "" --cancel-button "${txtexit}" --default-item "${nextitem}" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ "$?" = "0" ]; then
		case ${sel} in
            "${txtformatboot}")                
                if [ ! "${bootdev}" = "" ]; then
                    if (whiptail --backtitle "${apptitle}" --title "${txtformatdevices}" --yesno "${txtformatdeviceconfirm}" --defaultno 0 0) then
                        formatdevice boot ${bootdev}
						format_devices "${txtformatboot}"
						
                    fi
                fi
                nextitem="${txtformatboot}"
			;;
            "${txtformatswap}")                
                if [ ! "${swapdev}" = "" ]; then
                    if (whiptail --backtitle "${apptitle}" --title "${txtformatdevices}" --yesno "${txtformatdeviceconfirm}" --defaultno 0 0) then
                        formatdevice swap ${swapdev}
						format_devices "${txtformatswap}"
                    fi
                fi
                nextitem="${txtformatswap}"
			;;
            "${txtformatroot}")                
                if [ ! "${rootdev}" = "" ]; then
                    if (whiptail --backtitle "${apptitle}" --title "${txtformatdevices}" --yesno "${txtformatdeviceconfirm}" --defaultno 0 0) then
                        formatdevice root ${rootdev}
						format_devices "${txtformatroot}"
                    fi
                fi
                nextitem="${txtformatroot}"
			;;
            "${txtformathome}")                
                if [ ! "${homedev}" = "" ]; then
                    if (whiptail --backtitle "${apptitle}" --title "${txtformatdevices}" --yesno "${txtformatdeviceconfirm}" --defaultno 0 0) then
                        formatdevice home ${homedev}
						format_devices "${txtformathome}"
                    fi
                fi
                nextitem="${txtformathome}"
			;;
        esac 

		    
	else
		clear
	fi
	
	
}

formatdevice() {
	clear
    case ${1} in
        "boot")
            mkfs.fat -F32 ${2}
        ;;
        "swap")
            mkswap ${2}
        ;;
        "root")
            mkfs.ext4 ${2}
        ;;
        "home")
            mkfs.ext4 ${2}
        ;;

    esac
	
	lsblk -f
	pressanykey  
}

mountparts() {
	clear

	echo "mount ${rootdev} /mnt"
	mount ${rootdev} /mnt

	if [ ! "${bootdev}" = "" ]; then
		echo "mkdir -p /mnt/boot/efi"
		mkdir -p /mnt/boot/efi 2>/dev/null		
		echo "mount ${bootdev} /mnt/boot/efi"
		mount ${bootdev} /mnt/boot/efi
	fi

	if [ ! "${swapdev}" = "" ]; then
		echo "swapon ${swapdev}"
		swapon ${swapdev}
	fi

	if [ ! "${homedev}" = "" ]; then
		echo "mkdir -p /mnt/home"
		mkdir -p /mnt/home 2>/dev/null
		echo "mount ${homedev} /mnt/home"
		mount ${homedev} /mnt/home
	fi

	lsblk
	pressanykey
	
}

rebootpc(){
	if (whiptail --backtitle "${apptitle}" --title "${txtreboot}" --yesno "${txtreboot} ?" --defaultno 0 0) then
		clear
		unmountdevices
		reboot
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
	pressanykey
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
		pacman -Syy
		pressanykey
}


installbase(){
	
	options=()
	options+=("base" ")" on)
	options+=("base-devel" ")" on)
	options+=("linux" "" on)
	options+=("linux-headers" ")" on)
	options+=("linux-firmware" ")" on)
	options+=("amd-ucode" ")" on)
	options+=("neovim" ")" on)
	options+=("git" ")" on)	

	sel=$(whiptail --backtitle "${apptitle}" --title "${txtinstallarchlinux}" --checklist "" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ ! "$?" = "0" ]; then
		return 1
	fi
	for itm in $sel; do
		pkgs="$pkgs $(echo $itm | sed 's/"//g')"
	done
		
	clear
	tip "pacstrap /mnt ${pkgs}"
	pacstrap /mnt ${pkgs} arch-install-scripts wget libnewt vim
	pressanykey
}

archgenfstab() {
	clear
	tip "gen fstab"
	genfstab -U /mnt > /mnt/etc/fstab

	cat /mnt/etc/fstab
	pressanykey
}