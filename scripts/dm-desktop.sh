txtinstalldwm="Install dwm"
txtinstallsuckless="Install suckless software"
txtconfigsuckless="Config dwm"

installdwmmenu() {
    if [ "${1}" = "" ]; then
		nextitem="."
	else
		nextitem=${1}
	fi

	options=()
	options+=("${txtinstallsuckless}" "")
	options+=("${txtconfigsuckless}" "")

    sel=$(whiptail --backtitle "${apptitle}" --title "${txtinstalldwm}" --menu "" --cancel-button "${txtexit}" --default-item "${nextitem}" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ "$?" = "0" ]; then
		case ${sel} in
			"${txtinstallsuckless}")
				installsuckless
				nextitem="${txtconfigsuckless}"
			;;
			"${txtconfigsuckless}")
				configsuckless
				nextitem="${txtconfigsuckless}"
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
    options+=("dwmblocks-async" "" on)	
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
		if [ -d "$SUCKLESSDIR/${item}" ]; then
			tip "rm $SUCKLESSDIR/${item}"
			rm -r $SUCKLESSDIR/${item}
			
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
			        
	done

	tip "sudo pacman -S xorg xorg-xinit picom lxappearance qt5ct nautilus ark feh jq fzf baobab xautolock xfce4-power-manager eog webp-pixbuf-loader gnome-calculator parcellite numlockx dunst libnotify udisks2 udiskie gnome-keyring libsecret libgnome-keyring seahorse polkit-gnome maim xclip"
	sudo pacman -S xorg xorg-xinit picom lxappearance qt5ct nautilus ark feh jq fzf baobab xautolock xfce4-power-manager eog webp-pixbuf-loader gnome-calculator parcellite numlockx dunst libnotify udisks2 udiskie gnome-keyring libsecret libgnome-keyring seahorse polkit-gnome maim xclip
	tip "paru -S  j4-dmenu-desktop"
	paru -S  j4-dmenu-desktop      
	sudo systemctl enable udisks2
	pressanykey
}

configsuckless() {
	clear


	
	
	tip "Modify .xinitrc"
    cp /etc/X11/xinit/xinitrc ~/.xinitrc
    sed -i "/^twm &/d" ~/.xinitrc
    sed -i "/^xclock -geometry 50x50-1+1 &/d" ~/.xinitrc
    sed -i "/^xterm -geometry 80x50+494+51 &/d" ~/.xinitrc
    sed -i "/^xterm -geometry 80x20+494-0 &/d" ~/.xinitrc
    sed -i "/^exec xterm -geometry 80x66+0+0 -name login/d" ~/.xinitrc        

    echo  "xrdb -merge ~/.config/X11/Xresources/nord-dark" >> ~/.xinitrc 
    echo  "exec dwm" >> ~/.xinitrc 

	overwrightdotfiles common
	overwrightdotfiles dwm  
	
	
	pressanykey
}