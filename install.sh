#!/usr/bin/env bash
set -e

PWDIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

RED="\e[1;31m"
GREEN="\e[1;32m"
YELLOW="\e[3;33m"
BLUE="\e[3;34m"
GRAY="\e[3;37m"
ENDCOLOR="\e[0m"

tip() {
    echo -e "${GREEN}${1:-Done!}${ENDCOLOR}"
}

ptip() {
    read -p "$(echo -e $YELLOW${1:-Press enter to continue...}$ENDCOLOR)" temp
}

etip() {
    TIP="$($1)"
    echo -e "${GRAY}${TIP:-Done!}${ENDCOLOR}"
    read -p "$(echo -e $YELLOW${2:-Press enter to continue...}$ENDCOLOR)" temp
}

source ${PWDIR}/scripts/base.sh

apptitle="Arch Linux Fast Install"

loadstrings(){

	locale=en_US.UTF-8
	#font=

	txtexit="Exit"
	txtback="Back"
	txtignore="Ignore"

	txtmainmenu="Main Menu"
	txtsetdatetime="Set timedate"
	txtsetsourcelist="Set Source List"
	txtdiskpartmenu="Disk Partitions"
	txteditparts="Edit Partitions"
	txtselectpartsmenu="Select Partitions and Install"
	txtselectdevice="Select %1 device :"
	txtselecteddevices="Selected devices :"

	txtreboot="Reboot"
}






mainmenu(){
	if [ "${1}" = "" ]; then
		nextitem="."
	else
		nextitem=${1}
	fi
	options=()
	options+=("${txtsetdatetime}" "")	
	options+=("${txtsetsourcelist}" "")	
	options+=("${txtdiskpartmenu}" "")	
	options+=("${txtselectpartsmenu}" "")	
	options+=("" "")
	options+=("${txtreboot}" "")
	sel=$(whiptail --backtitle "${apptitle}" --title "${txtmainmenu}" --menu "" --cancel-button "${txtexit}" --default-item "${nextitem}" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ "$?" = "0" ]; then
		case ${sel} in
			"${txtsetdatetime}")
				settimedate
				nextitem="${txtreboot}"
			;;
			"${txtsetsourcelist}")
				setsourcelist
				nextitem="${txtreboot}"
			;;
			"${txtdiskpartmenu}")
				diskpartcgdisk
				nextitem="${txtselectpartsmenu}"
			;;
			"${txtselectpartsmenu}")
				selectparts
				nextitem="${txtreboot}"
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

if [ "${chroot}" = "1" ]; then
	case ${command} in
		'setrootpassword') archsetrootpasswordchroot;;
    esac
else
	systemctl stop reflector
	pacman -S --needed arch-install-scripts wget libnewt vim	
	loadstrings
	EDITOR=vim
	mainmenu
fi

exit 0