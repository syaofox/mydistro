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
    options+=("dwmblock" "" on)	
    options+=("slock" "" on)

    sel=$(whiptail --backtitle "${apptitle}" --title "${txtinstallsuckless}" --checklist "" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ ! "$?" = "0" ]; then
		return 1
	fi

    for itm in $sel; do
        item=$(echo $itm | sed 's/"//g')
        case ${item} in            
			"dwm")
                clear
                tip "Install dwm"
                cd $SUCKLESSDIR
                rm -rf $SUCKLESSDIR/dwm
                git clone https://github.com/syaofox/dwm.git $SUCKLESSDIR/dwm
                cd $SUCKLESSDIR/dwm
                git checkout main
                git branch  
                sudo make clean install
                make clean
                rm -f confg.h
                which dwm
                pressanykey				
            ;;
            "st")
                clear
                tip "Installing st..."
                cd $SUCKLESSDIR
                rm -rf $SUCKLESSDIR/st
                git clone https://github.com/syaofox/st.git $SUCKLESSDIR/st
                cd $SUCKLESSDIR/st
                git checkout main
                git branch    
                sudo make clean install
                make clean
                rm -f confg.h
                which st
                pressanykey				
			;;
        esac 
	done
}