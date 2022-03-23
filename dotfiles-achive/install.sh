#!/usr/bin/env bash
# set -e

PWDIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

RED="\e[1;31m"
GREEN="\e[1;32m"
YELLOW="\e[3;33m"
BLUE="\e[3;34m"
GRAY="\e[3;37m"
ENDCOLOR="\e[0m"


HOSTNAME="arch"
PLATFORM="AMD"
USERNAME="syaofox"
PASSWORD="0928"
SWAPSIZE="17408"

apptitle="Arch Linux Fast Install"
GITNAME="syaofox"
GITMAIL="syaofox@gmail.com"

USERHOME="/home/${USERNAME}"
REPODIR="${USERHOME}/Repos"

SUCKLESSDIR="${REPODIR}/suckless"

tip() {
    echo -e "${GREEN}${1:-Done!}${ENDCOLOR}"
}

pressanykey(){
	# read -n1 -p "${txtpressanykey}"
	read -n1 -p "$(echo -e $GREEN${txtpressanykey}$ENDCOLOR)"
}

ptip() {
    read -p "$(echo -e $YELLOW${1:-Press enter to continue...}$ENDCOLOR)" temp
}

etip() {
    TIP="$($1)"
    echo -e "${GRAY}${TIP:-Done!}${ENDCOLOR}"
    read -p "$(echo -e $YELLOW${2:-Press enter to continue...}$ENDCOLOR)" temp
}



source ${PWDIR}/scripts/strings.sh
source ${PWDIR}/scripts/base.sh
source ${PWDIR}/scripts/config.sh
source ${PWDIR}/scripts/desktop.sh



installpkgmenu() {
	if [ "${1}" = "" ]; then
		nextitem="."
	else
		nextitem=${1}
	fi

	options=()
	options+=("${txtinstallvideodrivers}" "  ${PLATFORM}")
	options+=("${txtinstallnetwork}" "")
	options+=("${txtinstallsoundandblooth}" "")
	options+=("${txtinstallutils}" "")
	sel=$(whiptail --backtitle "${apptitle}" --title "${txtInstallPkg}" --menu "" --cancel-button "${txtexit}" --default-item "${nextitem}" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ "$?" = "0" ]; then
		case ${sel} in
			"${txtinstallvideodrivers}")
				installvideodrivers
				nextitem="${txtinstallnetwork}"
			;;
			"${txtinstallnetwork}")
				installnetwork
				nextitem="${txtinstallsoundandblooth}"
			;;
			"${txtinstallsoundandblooth}")
				installsoundandblooth
				nextitem="${txtinstallutils}"
			;;
			"${txtinstallutils}")
				installutils
				nextitem="${txtinstallutils}"
			;;
		esac
		installpkgmenu "${nextitem}"
	fi
}


# TODO configmengu
configmenu(){
	if [ "${1}" = "" ]; then
		nextitem="."
	else
		nextitem=${1}
	fi

	options=()
	options+=("${txtsethostname}" "/etc/hostname")
	options+=("${txtsetlocale}" "/etc/locale.conf, /etc/locale.gen")
	options+=("${txtsettime}" "/etc/localtime")
	options+=("${txtsetrootpassword}" "")
	options+=("${txtadduser}" "  ${USERNAME}")
	options+=("${txtInstallPkg}" "")
	options+=("${txtconfigsamba}" "")	
	options+=("${txtinstallgrub}" "")

	sel=$(whiptail --backtitle "${apptitle}" --title "${txtarchinstallmenu}" --menu "" --cancel-button "${txtexit}" --default-item "${nextitem}" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ "$?" = "0" ]; then
		case ${sel} in			
			"${txtsethostname}")
				sethostname
				nextitem="${txtsetlocale}"
			;;
			"${txtsetlocale}")
				setlocale				
				nextitem="${txtsettime}"
			;;
			"${txtsettime}")
				setlocaltime				
				nextitem="${txtsetrootpassword}"
			;;
			"${txtsetrootpassword}")
				setrootpasswordchroot				
				nextitem="${txtadduser}"
			;;
			"${txtadduser}")
				adduser				
				nextitem="${txtInstallPkg}"
			;;
			"${txtInstallPkg}")
				installpkgmenu			
				nextitem="${txtconfigsamba}"
			;;
			"${txtconfigsamba}")
				configsamba			
				nextitem="${txtinstallgrub}"
			;;
			"${txtinstallgrub}")
				installgrub			
				nextitem="${txtinstallgrub}"
			;;
	esac
		configmenu "${nextitem}"
	fi
}

# TODO installmenu
installmenu(){
	if [ "${1}" = "" ]; then
		nextitem="${txtinstallarchlinux}"
	else
		nextitem=${1}
	fi
	options=()
	options+=("${txtselectmirrorsbycountry}" "(${txtoptional})")
	options+=("${txteditmirrorlist}" "(${txtoptional})")
	
	options+=("${txtinstallarchlinux}" "pacstrap")
	options+=("${txtgenfstab}" "/etc/fstab")
	options+=("${txtconfigarchlinux}" "")
	sel=$(whiptail --backtitle "${apptitle}" --title "${txtinstallmenu}" --menu "" --cancel-button "${txtunmount}" --default-item "${nextitem}" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ "$?" = "0" ]; then
		case ${sel} in
			"${txtselectmirrorsbycountry}")
				selectmirrorsbycountry
				nextitem="${txtinstallarchlinux}"
			;;
			"${txteditmirrorlist}")
				${EDITOR} /etc/pacman.d/mirrorlist
				nextitem="${txtinstallarchlinux}"
			;;
			"${txtinstallarchlinux}")
				if(installbase) then
					nextitem="${txtgenfstab}"
				fi
			;;
			"${txtgenfstab}")
				archgenfstab
				nextitem="${txtconfigarchlinux}"
			;;
			"${txtconfigarchlinux}")
				switchtochroot
				nextitem="${txtconfigarchlinux}"
			;;
		esac
		installmenu "${nextitem}"
	else
		unmountdevices
	fi
}




# TODO mainmenu
mainmenu(){
	if [ "${1}" = "" ]; then
		nextitem="."
	else
		nextitem=${1}
	fi
	options=()
	options+=("${txtsetdatetime}" "")	
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
				nextitem="${txtdiskpartmenu}"
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




# TODO main



if [ `whoami` = root ]; then

	while (( "$#" )); do
		case ${1} in	
			--chroot) 
				chroot=1
				command=${2}
				args=${3}
				
			;;
		esac
		shift
	done


	if [ "${chroot}" = "1" ]; then
		case ${command} in
			'config') 

				systemctl stop reflector
				pacman -S --noconfirm --needed arch-install-scripts wget libnewt vim	
				loadstrings
				EDITOR=vim
				configmenu
				exit
			;;
		esac
	else
		systemctl stop reflector
		pacman -S --noconfirm --needed arch-install-scripts wget libnewt vim	
		loadstrings
		EDITOR=vim
		mainmenu
	fi

else
	sudo pacman -Syy
	sudo pacman -S --noconfirm --needed arch-install-scripts wget libnewt vim	
	loadstrings
	EDITOR=vim
	desktopmenu
fi

exit 0