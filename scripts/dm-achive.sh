txtinstalldesktopenvironment="Install Desktop environment"

txtinstallparu="Install paru"

txtconfiggit="Config git"

txtconfiggitname="Config git username"
txtconfiggitmail="Config git mail"

txtinstallzsh="Install zsh"

txtinstalldesktop="Install desktop environment"
txtinstalldwm="Install dwm"
txtinstallsuckless="Install suckless software"
txtinstalldwmapps="Install dwm software"
txtinstallappearance="Install appearance"
txtinstallthemes="Install icons and themes"
txtinstallfonts="Install fonts"
txtinstalldm="Install display manager"
txtly="ly"
txtlyxinit="ly with xinit"
txtlyxsession="ly with xsession"
txtlightdm="lightdm"

txtselecttheme="Select theme"	
txtnordlight="nord light"
txtnorddark="nord dark"
txtteallight="teal light"
txttealdark="teal dark"
txttealgreen="teal green"


txtinstallgnome="Install gnome"
txtinstallkde="Install kde"
txtinstallxfce="Install xfce"
txtinstalllxqt="Install lxqt"

txtinstallsoftwares="Install softwares"


desktopmenu() {
	if [ "${1}" = "" ]; then
		nextitem="."
	else
		nextitem=${1}
	fi

	options=()
	options+=("${txtinstallparu}" "")
	options+=("${txtconfiggit}" "")
	options+=("${txtinstallzsh}" "")
	options+=("${txtinstalldesktop}" "")
	options+=("${txtinstallthemes}" "")
    options+=("${txtinstallfonts}" "")
	options+=("${txtinstallsoftwares}" "")
	sel=$(whiptail --backtitle "${apptitle}" --title "${txtinstalldesktopenvironment}" --menu "" --cancel-button "${txtexit}" --default-item "${nextitem}" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ "$?" = "0" ]; then
		case ${sel} in
			"${txtinstallparu}")
				installparu
				nextitem="${txtconfiggit}"
			;;
            "${txtconfiggit}")
				configgit
				nextitem="${txtinstallzsh}"
			;;
            "${txtinstallzsh}")
				installzsh
				nextitem="${txtinstalldesktop}"
			;;
            "${txtinstalldesktop}")
				installdesktopmenu
				nextitem="${txtinstallthemes}"
			;;
            "${txtinstallthemes}")
				installthemes
				nextitem="${txtinstallfonts}"
			;;

            "${txtinstallfonts}")
				installfontsmenu
				nextitem="${txtinstallsoftwares}"
			;;
			"${txtinstallsoftwares}")
				installsoftwaresmenu
				nextitem="${txtinstallsoftwares}"
			;;
		esac
		desktopmenu "${nextitem}"
	fi
}

installparu() {
    clear   
    tip "Install Paru ${REPODIR}"
    mkdir -p $REPODIR
    cd $REPODIR
    git clone https://aur.archlinux.org/paru.git $REPODIR/paru
    cd $REPODIR/paru
    makepkg -si
    paru -Syy   

    which paru
    pressanykey

}

configgit() {
    tip "Config git..."

    GITNAME=$(whiptail --backtitle "${apptitle}" --title "${txtconfiggitname}" --inputbox "" 0 0 "${GITNAME}" 3>&1 1>&2 2>&3)
	if [ "$?" = "0" ]; then
		git config --global user.name ${GITNAME}
	fi

    GITMAIL=$(whiptail --backtitle "${apptitle}" --title "${txtconfiggitmail}" --inputbox "" 0 0 "${GITMAIL}" 3>&1 1>&2 2>&3)
	if [ "$?" = "0" ]; then
		git config --global user.name ${GITNAME}
	fi

    clear
    git config --global user.name ${GITNAME}
    git config --global user.email "${GITMAIL}"
    ssh-keygen -t rsa -b 4096 -C "${GITMAIL}"
    cat ${HOME}/.ssh/id_rsa.pub
    pressanykey
}


installzsh() {
    clear
    tip "Install zsh..."
    sudo pacman -S --noconfirm zsh 
    paru -S --noconfirm zplug
    cp ${PWDIR}/dotfiles/init/.zshrc ~/.zshrc
    cat ${HOME}/.zshrc
    pressanykey
}

# TODO
installdesktopmenu() {
    if [ "${1}" = "" ]; then
		nextitem="."
	else
		nextitem=${1}
	fi

	options=()
	options+=("${txtinstalldwm}" "")
	options+=("${txtinstallgnome}" "")
	options+=("${txtinstallkde}" "")
	options+=("${txtinstallxfce}" "")
	options+=("${txtinstalllxqt}" "")

    sel=$(whiptail --backtitle "${apptitle}" --title "${txtinstalldesktop}" --menu "" --cancel-button "${txtexit}" --default-item "${nextitem}" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ "$?" = "0" ]; then
		case ${sel} in
			"${txtinstalldwm}")
				installdwmmenu
                pressanykey
				nextitem="${txtinstalldwm}"
			;;
			"${txtinstallgnome}")
				installgnome
				nextitem="${txtinstallgnome}"
			;;
			"${txtinstallkde}")
				installkde
				nextitem="${txtinstallkde}"
			;;
			"${txtinstalllxqt}")
				installlxqt
				nextitem="${txtinstalllxqt}"
			;;
            
        esac
		installdesktopmenu "${nextitem}"
	fi

}


installdwmmenu() {
    if [ "${1}" = "" ]; then
		nextitem="."
	else
		nextitem=${1}
	fi

	options=()
	options+=("${txtinstallsuckless}" "")
	options+=("${txtinstalldm}" "")
    options+=("${txtinstalldwmapps}" "")
    options+=("${txtinstallappearance}" "")  
    options+=("${txtselecttheme}" "")  

    sel=$(whiptail --backtitle "${apptitle}" --title "${txtinstalldwm}" --menu "" --cancel-button "${txtexit}" --default-item "${nextitem}" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ "$?" = "0" ]; then
		case ${sel} in
			"${txtinstallsuckless}")
				installsuckless
				nextitem="${txtinstalldm}"
			;;
			"${txtinstalldm}")
				installdmmenu
				nextitem="${txtinstalldwmapps}"
			;;
            "${txtinstalldwmapps}")
				installdwmapps
				nextitem="${txtinstallappearance}"
			;;
            "${txtinstallappearance}")
				installappearance
				nextitem="${txtselecttheme}"
			;;

            "${txtselecttheme}")
				selecttheme
				nextitem="${txtselecttheme}"
			;;
            
           
        esac
		installdwmmenu "${nextitem}"
	fi
}

installsuckless() {
    if [ "${1}" = "" ]; then
		nextitem="."
	else
		nextitem=${1}
	fi
    options=()
    options+=("dwm" "" on)	
    options+=("dmenu" "" on)	
    options+=("st" "" on)	
    options+=("slstatus" "" on)	
    options+=("slock" "" on)

    sel=$(whiptail --backtitle "${apptitle}" --title "${txtinstallsuckless}" --checklist "" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ ! "$?" = "0" ]; then
		return 1
	fi
    dwminstall=0
    dmenuinstall=0
    stinstall=0
    slstatusinstall=0
    slockinstall=0
	for itm in $sel; do
        item=$(echo $itm | sed 's/"//g')
        case ${item} in            
			"dwm")
                dwminstall=1				
			;;
			"dmenu")
                dmenuinstall=1				
			;;
			"st")
                stinstall=1				
			;;
			"slstatus")
                slstatusinstall=1				
			;;
			"slock")
                slockinstall=1				
			;;
        esac 
	done
    clear
    mkdir -p $SUCKLESSDIR        

    if [ $dwminstall = 1 ]; then
        clear
        tip "Install dwm"
        cd $SUCKLESSDIR
        rm -rf $SUCKLESSDIR/dwm
        git clone https://github.com/syaofox/dwm.git $SUCKLESSDIR/dwm
        cd $SUCKLESSDIR/dwm
        git checkout x
        git branch    
        sudo make clean install
        make clean
        rm -f confg.h
        which dwm
        pressanykey
    fi

    if [ $dmenuinstall = 1 ]; then
        clear
        tip "Installing dmenu..."
        cd $SUCKLESSDIR
        rm -rf $SUCKLESSDIR/dmenu
        git clone https://github.com/syaofox/dmenu.git $SUCKLESSDIR/dmenu
        cd $SUCKLESSDIR/dmenu
        git checkout x
        git branch
        sudo make clean install
        make clean
        rm -f confg.h
        which dmenu
        pressanykey
    fi

    if [ $stinstall = 1 ]; then
        clear
        tip "Installing st..."
        cd $SUCKLESSDIR
        rm -rf $SUCKLESSDIR/st
        git clone https://github.com/syaofox/st.git $SUCKLESSDIR/st
        cd $SUCKLESSDIR/st
        git checkout x
        git branch    
        sudo make clean install
        make clean
        rm -f confg.h
        which st
        pressanykey
    fi

    if [ $slstatusinstall = 1 ]; then
        clear
        tip "Installing slstatus..."
        cd $SUCKLESSDIR
        rm -rf $SUCKLESSDIR/slstatus
        git clone https://github.com/syaofox/slstatus.git $SUCKLESSDIR/slstatus
        cd $SUCKLESSDIR/slstatus
        git checkout dev
        git branch    
        sudo make clean install
        make clean
        rm -f confg.h
        which slstatus
        pressanykey
    fi

    if [ $slockinstall = 1 ]; then
        clear
        tip "Installing slock..."
        cd $SUCKLESSDIR
        rm -rf $SUCKLESSDIR/slock
        git clone https://github.com/syaofox/arch-slock.git $SUCKLESSDIR/slock
        cd $SUCKLESSDIR/slock
        git checkout dev
        git branch    
        sudo make clean install
        make clean
        rm -f confg.h
        which slock
        pressanykey
        
    fi

    clear
    tip "Setting environment"

    cp $PWDIR/dotfiles/init/.profile ~/.profile
    cat ~/.profile
    pressanykey

    clear
    tip "Setting dwm scripts"
    mkdir -p  ~/.dwm
    cp -r $PWDIR/dotfiles/.dwm/* ~/.dwm/
    sudo chmod +x ~/.dwm/*    
    ls ${HOME}/.dwm/ -la   
    pressanykey


    tip "Install custom bin scripts"
    sudo cp -r $PWDIR/dotfiles/bin/* /usr/local/bin/
    sudo chmod +x /usr/local/bin/dmenu-websearch
    sudo chmod +x /usr/local/bin/dm-kill
    sudo chmod +x /usr/local/bin/dm-mount
    sudo chmod +x /usr/local/bin/dm-power
    sudo chmod +x /usr/local/bin/dm-theme
    sudo chmod +x /usr/local/bin/fftovr
    sudo chmod +x /usr/local/bin/mangaman
    sudo chmod +x /usr/local/bin/metainfo
    sudo chmod +x /usr/local/bin/sb-date     
    
    which dmenu-websearch
    which dm-kill
    which dm-mount
    which dm-power
    which dm-theme
    which fftovr
    which mangaman
    which metainfo
    which sb-date
    which rwp

    pressanykey

    tip "Install custom application"
    sudo cp -r $PWDIR/dotfiles/applications/* /usr/share/applications
    ls /usr/share/applications/dm-power.desktop
    ls /usr/share/applications/dm-theme.desktop
    ls /usr/share/applications/dm-mount.desktop

    pressanykey

    installsuckless "${nextitem}"
}


installdmmenu() {

    if [ "${1}" = "" ]; then
		nextitem="."
	else
		nextitem=${1}
	fi

    options=()
	options+=("${txtly}" "")
	options+=("${txtlightdm}" "")
   
    sel=$(whiptail --backtitle "${apptitle}" --title "${txtinstalldm}" --menu "" --cancel-button "${txtexit}" --default-item "${nextitem}" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ "$?" = "0" ]; then
		case ${sel} in
			"${txtly}")
				lyconfig
				nextitem="${txtly}"
			;;	
			"${txtlightdm}")
				lightdmconfig
				nextitem="${txtlightdm}"
			;;	
        esac
		installdmmenu "${nextitem}"
	fi

   
}

installdwmapps() {
    clear
    #pcmanfm gtk-engine-murrine
    sudo pacman -S --noconfirm nautilus  ark feh jq volumeicon blueberry xfce4-power-manager xfce4-screenshooter eog webp-pixbuf-loader gnome-calculator parcellite numlockx
    mkdir -p ~/Pictures/screenshots  
    ls ${HOME}/Pictures/screenshots -l
    pressanykey

    sudo pacman -S --noconfirm dunst libnotify
    tip "Setting .dunst"
    mkdir -p ~/.config/dunst
    cp $PWDIR/dotfiles/dunst/dunstrc ~/.config/dunst/dunstrc
    cat ${HOME}/.config/dunst/dunstrc
    pressanykey

    sudo pacman -S --noconfirm udisks2 udiskie pacman gnome-keyring libsecret libgnome-keyring seahorse
    sudo systemctl enable udisks2
    paru -S --noconfirm j4-dmenu-desktop    
    pressanykey
}

installappearance() {
    clear
    tip "Install appearacne..."

    sudo pacman -S --noconfirm xorg xorg-xinit  

    tip "Setting picom"
    sudo pacman -S --noconfirm picom 
    cp ${PWDIR}/dotfiles/picom/picom.conf ~/.config/picom.conf    
    ls ${HOME}/.config/picom.conf
    pressanykey

    sudo pacman -S --noconfirm lxappearance qt5ct
    paru -S --noconfirm qt5-styleplugins
    echo "QT_QPA_PLATFORMTHEME=qt5ct" >> ~/.pam_environment

    cat  ${HOME}/.pam_environment
    pressanykey

    paru -S libxft-bgra
    pressanykey
}


selecttheme() {
    if [ "${1}" = "" ]; then
		nextitem="."
	else
		nextitem=${1}
	fi

    options=()
	options+=("${txtnordlight}" "")
	options+=("${txtnorddark}" "")
	options+=("${txtteallight}" "")
	options+=("${txttealdark}" "")
	options+=("${txttealgreen}" "")  

    sel=$(whiptail --backtitle "${apptitle}" --title "${txtselecttheme}" --menu "" --cancel-button "${txtexit}" --default-item "${nextitem}" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ "$?" = "0" ]; then
		case ${sel} in
			"${txtnordlight}")
                settheme nord-light
				nextitem="${txtnordlight}"
			;;
			"${txtnorddark}")
                settheme nord-dark
				nextitem="${txtnorddark}"
			;;
            "${txtteallight}")
                settheme teal-light
				nextitem="${txtteallight}"
			;;
            "${txttealdark}")
                settheme teal-dark
				nextitem="${txttealdark}"
			;;
			"${txttealgreen}")
				settheme teal-green
				nextitem="${txttealgreen}"
			;;
			       
           
        esac
		selecttheme "${nextitem}"
	fi
}

installsoftwaresmenu() {

    # vdhcoapp-bin firefox freedownloadmanager visual-studio-code-bin xnconvert xnviewmp lx-music-desktop-bin gimp bulky 
    options=()
    options+=("codecs" "" on)	
    options+=("mpv" "" on)	
    options+=("vlc" "" off)	
	options+=("firefox" "  Standalone web browser from mozilla.org" on)
	options+=("freedownloadmanager" "" on)
	options+=("visual-studio-code-bin" "" on)
	options+=("xnconvert" "" on)
	options+=("xnviewmp" "" on)
	options+=("lx-music-desktop-bin" "" on)	
	options+=("gimp" "" on)	
	options+=("bulky" "" on)
    options+=("ffmpegthumbnailer" "" on)		
	options+=("ark" "" on)	
	options+=("xarchiver" "" off)	
	options+=("file-roller" "" off)	
	options+=("engrampa" "" off)	
	options+=("vm" "" off)	
	pacmanpkgs=""
    parupkgs=""
	
    configmpv=0
    configvm=0

	sel=$(whiptail --backtitle "${apptitle}" --title "${txtinstallarchlinuxfilesystems}" --checklist "" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ ! "$?" = "0" ]; then
		return 1
	fi
	for itm in $sel; do
        item=$(echo $itm | sed 's/"//g')
        case ${item} in
            
			"codecs")
                pacmanpkgs="$pacmanpkgs gstreamer gst-libav gst-plugins-bad gst-plugins-base gst-plugins-good gst-plugins-ugly"
				
			;;
			"mpv")
                configmpv=1
				pacmanpkgs="$pacmanpkgs $item"
            ;;
			"firefox")                
				pacmanpkgs="$pacmanpkgs $item"
            ;;
			"freedownloadmanager")                
				parupkgs="$parupkgs $item vdhcoapp-bin"
            ;;
			"visual-studio-code-bin")                
				parupkgs="$parupkgs $item"
            ;;
			"xnconvert")                
				parupkgs="$parupkgs $item"
            ;;
			"xnviewmp")                
				parupkgs="$parupkgs $item"
            ;;
			"lx-music-desktop-bin")                
				parupkgs="$parupkgs $item"
            ;;
			"gimp")                
				parupkgs="$parupkgs $item"
            ;;
			"bulky")                
				parupkgs="$parupkgs $item"
            ;;
			"ffmpegthumbnailer")                
				pacmanpkgs="$pacmanpkgs $item"
            ;;
			"ark")                
				pacmanpkgs="$pacmanpkgs $item"
            ;;
			"xarchiver")                
				pacmanpkgs="$pacmanpkgs $item"
            ;;
			"file-roller")                
				pacmanpkgs="$pacmanpkgs $item"
            ;;
			"engrampa")                
				pacmanpkgs="$pacmanpkgs $item"
            ;;			
			"vm")
                configvm=1         
				pacmanpkgs="$pacmanpkgs virt-manager qemu qemu-arch-extra edk2-ovmf bridge-utils dnsmasq vde2 openbsd-netcat libguestfs"
            ;;			
		esac

	done
		
	clear
    if [ ${parupkgs} ]; then
        tip "pacman -S ${pacmanpkgs}"
        sudo pacman -S --noconfirm ${pacmanpkgs}
        pressanykey
    fi

    if [ ${parupkgs} ]; then
        tip "paru -S ${parupkgs}"
        paru -S --noconfirm ${parupkgs}
        pressanykey
    fi

   
    if [ $configmpv = 1 ]; then
        tip "Config mpv"
        mkdir ~/.config
        cp -r /usr/share/doc/mpv/ ~/.config/
        echo "sub-auto=fuzzy" >> ~/.config/mpv/mpv.conf
        echo "profile=gpu-hq" >> ~/.config/mpv/mpv.conf
        echo "scale=ewa_lanczossharp" >> ~/.config/mpv/mpv.conf
        echo "cscale=ewa_lanczossharp" >> ~/.config/mpv/mpv.conf
        echo "video-sync=display-resample" >> ~/.config/mpv/mpv.conf
        echo "interpolation" >> ~/.config/mpv/mpv.conf
        echo "tscale=oversample" >> ~/.config/mpv/mpv.conf 

        tail -n 10 ${HOME}/.config/mpv/mpv.conf
        pressanykey
    fi

    if [ $configvm = 1 ]; then
        tip "Config vm"
        sudo systemctl enable libvirtd
        sudo usermod -aG libvirt $USERNAME 
        id
        pressanykey
    fi
}






settheme() {
    tip "setting ${1:-nord-light}"
    clear
    tip "Setting .Xresources"
    cp $PWDIR/dotfiles/X11/${1:-nord-light}/.Xresources ~/.Xresources  
    ls ${HOME}/.Xresources -la
    pressanykey

    clear
    tip "Setting wallpapers"
    mkdir -p ~/Pictures/wallpapers
    cp ${PWDIR}/dotfiles/X11/${1:-nord-light}/${1:-nord-light}-16x10.jpg ~/Pictures/wallpapers
    cp ${PWDIR}/dotfiles/X11/${1:-nord-light}/${1:-nord-light}-21x9.jpg ~/Pictures/wallpapers
    ls ~/Pictures/wallpapers
    pressanykey
    
    sed -i 's/.*feh.*/feh --bg-fill ~\/Pictures\/wallpapers\/'${1:-nord-light}'-16x10.jpg ~\/Pictures\/wallpapers\/'${1:-nord-light}'-21x9.jpg/' ~/.xinitrc
    sed -i 's/.*feh.*/feh --bg-fill ~\/Pictures\/wallpapers\/'${1:-nord-light}'-16x10.jpg ~\/Pictures\/wallpapers\/'${1:-nord-light}'-21x9.jpg/' ~/.xsession

    cp $PWDIR/dotfiles/X11/${1:-nord-light}/.Xresources ~/.Xresources  
    ls ${HOME}/.Xresources -la
    pressanykey


    clear
    tip "Setting gtk theme"
    mkdir -p  ~/.config/gtk-3.0/
    cp ${PWDIR}/dotfiles/X11/${1:-nord-light}/settings.ini  ~/.config/gtk-3.0/settings.ini
    cp ${PWDIR}/dotfiles/X11/${1:-nord-light}/.gtkrc-2.0 ~/.gtkrc-2.0   
    ls ~/Pictures/wallpapers
    pressanykey
}





dwmsessionconfig() {
    tip "Set dwm.desktop"
    sudo mkdir -p /usr/share/xsessions
    sudo cp $PWDIR/dotfiles/X11/dwm.desktop /usr/share/xsessions/dwm.desktop
    cat /usr/share/xsessions/dwm.desktop
    pressanykey

    tip "Set .xsession"
    cat  $PWDIR/dotfiles/X11/.xsession > ~/.xsession
    sudo chmod +x ~/.xsession        
    cat ${HOME}/.xsession

    pressanykey
}

lyconfig() {
    clear
    
    paru -S --noconfirm ly
    sudo systemctl enable ly
    
    tip "Modify .xinitrc"
    cp /etc/X11/xinit/xinitrc ~/.xinitrc
    sed -i "/^twm &/d" ~/.xinitrc
    sed -i "/^xclock -geometry 50x50-1+1 &/d" ~/.xinitrc
    sed -i "/^xterm -geometry 80x50+494+51 &/d" ~/.xinitrc
    sed -i "/^xterm -geometry 80x20+494-0 &/d" ~/.xinitrc
    sed -i "/^exec xterm -geometry 80x66+0+0 -name login/d" ~/.xinitrc        

    cat  $PWDIR/dotfiles/init/.xinitrc >> ~/.xinitrc
    sudo chmod +x ~/.xinitrc        
    cat ${HOME}/.xinitrc
    
    pressanykey

    dwmsessionconfig
}

lightdmconfig() {
    tip "Install lightdm"

    sudo pacman -S --noconfirm lightdm lightdm-gtk-greeter
    sudo systemctl enable lightdm

    pressanykey

    dwmsessionconfig
}


lyxinit() {
    clear
    
    paru -S --noconfirm ly
    sudo systemctl enable ly
    
    tip "Modify .xinitrc"
    cp /etc/X11/xinit/xinitrc ~/.xinitrc
    sed -i "/^twm &/d" ~/.xinitrc
    sed -i "/^xclock -geometry 50x50-1+1 &/d" ~/.xinitrc
    sed -i "/^xterm -geometry 80x50+494+51 &/d" ~/.xinitrc
    sed -i "/^xterm -geometry 80x20+494-0 &/d" ~/.xinitrc
    sed -i "/^exec xterm -geometry 80x66+0+0 -name login/d" ~/.xinitrc        

    cat  $PWDIR/dotfiles/init/.xinitrc >> ~/.xinitrc
    sudo chmod +x ~/.xinitrc        
    cat ${HOME}/.xinitrc
    
    pressanykey
    
}

lyxsession() {
    clear
    
    paru -S --noconfirm ly
    sudo systemctl enable ly
    pressanykey
    
    tip "Set dwm.desktop"
    sudo mkdir -p /usr/share/xsessions
    sudo cp $PWDIR/dotfiles/X11/dwm.desktop /usr/share/xsessions/dwm.desktop
    cat /usr/share/xsessions/dwm.desktop
    pressanykey

    cat  $PWDIR/dotfiles/X11/.xsession > ~/.xsession
    sudo chmod +x ~/.xsession        
    cat ${HOME}/.xsession

    pressanykey
}



# TODO installfontsmenu
installfontsmenu() {
          	  
    options=()
    options+=("ttf-nerd-fonts-symbols-mono" "" on)	
    options+=("noto-fonts" "" on)	
	options+=("noto-fonts-cjk" "" on)
	options+=("noto-fonts-emoji" "" on)
	options+=("ttf-roboto-mono" "" on)	
	options+=("ttf-roboto" "" on)	
	options+=("wqy-zenhei" "" on)	
	options+=("wqy-microhei" "" on)	

	sel=$(whiptail --backtitle "${apptitle}" --title "${txtinstallfonts}-pacman" --checklist "" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ ! "$?" = "0" ]; then
		return 1
	fi
    pacmanpkgs=""
    parupkgs=""

    for itm in $sel; do
		pacmanpkgs="$pacmanpkgs $(echo $itm | sed 's/"//g')"
	done

    options=()
    options+=("ttf-lxgw-wenkai" "" on)	
    options+=("ttf-lxgw-wenkai-mono-lite" "" on)	
    options+=("ttf-lxgw-wenkai-lite" "" on)	
    sel=$(whiptail --backtitle "${apptitle}" --title "${txtinstallfonts}-aur" --checklist "" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)

	if [ ! "$?" = "0" ]; then
		return 1
	fi
    
    for itm in $sel; do
		parupkgs="$parupkgs $(echo $itm | sed 's/"//g')"
	done


    clear
		
	tip "pacman -S ${pacmanpkgs}"
	sudo pacman -S --noconfirm ${pacmanpkgs}
	pressanykey

    clear
	tip "paru -S ${parupkgs}"
	paru -S --noconfirm ${parupkgs}
	pressanykey  

    clear
    tip "Install fcitx5"
    sudo pacman -S --noconfirm fcitx5-im fcitx5-chinese-addons fcitx5-material-color fcitx5-nord fcitx5-pinyin-zhwiki 
    paru -S --noconfirm fcitx5-pinyin-moegirl
    

    tip "Open freetype2"
    sudo sed -i 's/#\(export FREETYPE_PROPERTIES\)/\1/' /etc/profile.d/freetype2.sh
    cat /etc/profile.d/freetype2.sh
    pressanykey


    # 字体配置
    tip "Setting fontconfig..."
    FONTCONFIG="${USERHOME}/.config/fontconfig"
    mkdir -p $FONTCONFIG
    cp ${PWDIR}/dotfiles/fontconfig/fonts.conf $FONTCONFIG/fonts.conf   
    cat ${FONTCONFIG}/fonts.conf
    pressanykey


    # 输入法配置
    tip "Setting fcitx5..."

    PAM="${USERHOME}/.pam_environment"
    tip "Setting fcitx5 environment..."    
    sed -i "/^GTK_IM_MODULE/d" $PAM
    sed -i "/^QT_IM_MODULE/d" $PAM
    sed -i "/^XMODIFIERS/d" $PAM
    sed -i "/^INPUT_METHOD/d" $PAM
    sed -i "/^SDL_IM_MODULE/d" $PAM
    sed -i "/^GLFW_IM_MODULE/d" $PAM
    echo "GTK_IM_MODULE DEFAULT=fcitx" >> $PAM
    echo "QT_IM_MODULE  DEFAULT=fcitx" >> $PAM
    echo "XMODIFIERS    DEFAULT=\@im=fcitx" >> $PAM
    echo "INPUT_METHOD  DEFAULT=fcitx" >> $PAM
    echo "SDL_IM_MODULE DEFAULT=fcitx" >> $PAM
    echo "GLFW_IM_MODULE DEFAULT=ibus" >> $PAM
    cat $PAM
    pressanykey

    tip "Setting fcitx5 punctuation..."
    PUNC_FILE="/usr/share/fcitx5/punctuation/punc.mb.zh_CN"
    sudo sed -i "/^\[/d" $PUNC_FILE
    echo "[ 【"  | sudo tee -a $PUNC_FILE
    sudo sed -i "/^\]/d" $PUNC_FILE
    echo "] 】" | sudo tee -a $PUNC_FILE
    sudo sed -i "/^\`/d" $PUNC_FILE
    echo "\` ·" | sudo tee -a $PUNC_FILE
    cat $PUNC_FILE
    pressanykey
}





installgnome() {
    clear
    tip "${txtinstallgnome}"

    sudo pacman -S --noconfirm xorg gdm gnome gnome-extra firefox gnome-tweaks gnome-software-packagekit-plugin webp-pixbuf-loader flatpak 
    sudo systemctl enable gdm
    paru -S --noconfirm chrome-gnome-shell  gnome-terminal-transparency 
    pressanykey
}

installkde() {
    clear
    tip "${txtinstallkde}"
    sudo pacman -S --noconfirm org sddm plasma kde-applications
    sudo systemctl enable sddm
    paru -S --noconfirm gnome-software-packagekit-plugin 
    pressanykey
}

installxfce() {
    clear
    tip "${txtinstallxfce}"
    sudo pacman -S --noconfirm xorg lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings xfce4 xfce4-goodies 
    sudo systemctl enable lightdm
    pressanykey
}

installlxqt() {
    clear
    tip "sudo pacman -S --noconfirm lxqt lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings ffmpegthumbnailer"
    sudo pacman -S --noconfirm xorg lxqt lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings ffmpegthumbnailer
    sudo systemctl enable lightdm
    pressanykey
}

installthemes() {  

    options=()
    options+=("arc" "" on)	
    options+=("papirus" "" on)	
	options+=("breeze" "" on)
	options+=("mint" "" on)
	options+=("orchis" "" on)	
	options+=("nordic" "" on)
	options+=("qogir" "" on)

	sel=$(whiptail --backtitle "${apptitle}" --title "${txtinstallarchlinuxfilesystems}" --checklist "" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ ! "$?" = "0" ]; then
		return 1
	fi
    pacmanpkgs=""
    parupkgs=""
	for itm in $sel; do
        item=$(echo $itm | sed 's/"//g')
        case ${item} in
            
			"arc")
                pacmanpkgs="$pacmanpkgs arc-gtk-theme arc-icon-theme"
				
			;;
			"papirus")

				pacmanpkgs="$pacmanpkgs papirus-icon-theme"
            ;;
			"breeze")                
				pacmanpkgs="$pacmanpkgs breeze breeze-icons breeze-gtk"
            ;;
			"mint")                
				parupkgs="$parupkgs mint-themes mint-x-icons mint-y-icons"
            ;;
			"orchis")                
				parupkgs="$parupkgs orchis-theme"
            ;;
			"nordic")                
				parupkgs="$parupkgs nordic-theme"
            ;;			
			"qogir")                
				parupkgs="$parupkgs  qogir-gtk-theme  fluent-cursor-theme-git qogir-icon-theme"
            ;;			
		esac
	done
		
	clear

	tip "pacman -S ${pacmanpkgs}"
	sudo pacman -S --noconfirm ${pacmanpkgs}
	pressanykey

	tip "paru -S ${parupkgs}"
	paru -S --noconfirm ${parupkgs}
	pressanykey  
}







