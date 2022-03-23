#!/usr/bin/env bash
# set -e

EDITOR=vim
PWDIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
PWDIRNAME="$(basename "$PWDIR")"

RED="\e[1;31m"
GREEN="\e[1;32m"
YELLOW="\e[3;33m"
BLUE="\e[3;34m"
GRAY="\e[3;37m"
ENDCOLOR="\e[0m"

HOSTNAME="arch"
PLATFORM="AMD"
SOUNDTYPE="PIPEWIRE"
USERNAME="syaofox"
PASSWORD="0928"

USERHOME="/home/${USERNAME}"
REPODIR="${USERHOME}/Repos"
SUCKLESSDIR="${REPODIR}/suckless"

apptitle="Arch Linux Fast Install"
GITNAME="syaofox"
GITMAIL="syaofox@gmail.com"

txtexit="Exit"
txtback="Back"
txtignore="Ignore"
txtpressanykey="Press any key to continue."
txtoptional="Optional"

tip() {
    echo -e "${GREEN}${1:-Done!}${ENDCOLOR}"
}




pressanykey(){
	# read -n1 -p "${txtpressanykey}"
	read -n1 -p "$(echo -e $GREEN${txtpressanykey}$ENDCOLOR)"
}

# chroot run
archchroot(){
	
	arch-chroot /mnt /root/${PWDIRNAME}/$(basename "${0}") --chroot ${1} ${2}

}



source ${PWDIR}/scripts/base.sh
source ${PWDIR}/scripts/chroot.sh
source ${PWDIR}/scripts/dm-desktop.sh
source ${PWDIR}/scripts/dm.sh


# tip "${PWDIR}"
# tip "${PWDIRNAME}"
# pressanykey

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
			'sethostname') chrootsethostname;;
			'setlocaleandtime') chrootsetlocaleandtime;;
			'adduserandchpasswd') chrootadduserandchpasswd;;
			'installvideodrivers') chrootinstallvideodrivers;;
			'installsoundand') chrootinstallsoundand;;
			'installnetwork') chrootinstallnetwork;;
			'installutils') chrootinstallutils;;
			'configsamba') chrootconfigsamba;;
			'installgrub') chrootinstallgrub;;
		esac
	else
		systemctl stop reflector
		pacman -S --noconfirm --needed arch-install-scripts wget libnewt vim	
		mainmenu
	fi

else
	while (( "$#" )); do
		case ${1} in	
			config) 
				config=1
				command=${2}
				args=${3}
				
			;;
		esac
		shift
	done

	if [ "${config}" = "1" ]; then
		echo "${txtoverwrightdwmdotfiles}"
		configmenu
	else
		sudo pacman -Syy
		sudo pacman -S --noconfirm --needed arch-install-scripts wget libnewt vim		
		desktopmenu
	fi
fi