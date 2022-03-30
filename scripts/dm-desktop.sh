txtinstalldwm="Install dwm"
txtinstallsuckless="Install suckless software"

installdwmmenu() {
    if [ "${1}" = "" ]; then
		nextitem="."
	else
		nextitem=${1}
	fi

	options=()
	options+=("${txtinstallsuckless}" "")

    sel=$(whiptail --backtitle "${apptitle}" --title "${txtinstalldwm}" --menu "" --cancel-button "${txtexit}" --default-item "${nextitem}" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ "$?" = "0" ]; then
		case ${sel} in
			"${txtinstallsuckless}")
				installsuckless
				nextitem="${txtinstalldm}"
			;;
        esac
		installdwmmenu "${nextitem}"
	fi
}

installsuckless(){
    if [ "${1}" = "" ]; then
		nextitem="."
	else
		nextitem=${1}
	fi
    options=()
    options+=("dwm" "" on)    	
    options+=("st" "" on)
    options+=("dmenu" "" on)	
    options+=("dwmblockdwmblocks-async" "" on)	
    options+=("slock" "" on)

    sel=$(whiptail --backtitle "${apptitle}" --title "${txtinstallsuckless}" --checklist "" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ ! "$?" = "0" ]; then
		return 1
	fi

    for itm in $sel; do
        item=$(echo $itm | sed 's/"//g')

		 clear
		tip "Install $item"
		cd $SUCKLESSDIR
		if [ -d "$SUCKLESSDIR" ]; then
			rm -r $SUCKLESSDIR/${item}
			tip "rm $SUCKLESSDIR/${item}"
		fi
		git clone https://github.com/syaofox/${item}.git $SUCKLESSDIR/${item}
		cd $SUCKLESSDIR/${item}
		git checkout main
		git branch  
		sudo make clean install
		make clean
		if [ -f "confg.def.h" ]; then
			rm -f confg.h
			tip "rm config.h"
		fi
		
		which ${item}
		pressanykey	        
	done
}