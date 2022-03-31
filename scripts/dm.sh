#!/usr/bin/env bash
# set -e

#aur xob volumeicon nutstore youtube-dl ttf-symbola 

# sh ~/.fehbg
# wmname compiz

# arr=("goblocks" "xfce4-power-man" "copyq" "fcitx5" "dunst" "solaar" "nutstore" "qbittorrent" "mpd")

# for value in ${arr[@]}; do
#     if [[ ! $(pgrep ${value}) ]]; then
#         exec "$value" &
#     fi
# done

# if [[ ! $(pgrep xob) ]]; then
#     exec "sxob"
# fi

# pacman light jq xorg-xev fzf xfce4-terminal ttf-joypixels baobab gnome-calendar xautolock

# PWDIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# cp -avf $PWDIR/dotfiles/dwm/users/. ~/ 

# sudo systemctl enable fstrim.timer

# sudo cp -avf $PWDIR/dotfiles/dwm/root/usr/share/xsessions/dwm.desktop /usr/share/xsessions/dwm.desktop

# flatpak need xdg-desktop-portal 
# aur 
    # nerd-fonts-ibm-plex-mono
    # nerd-fonts-fira-code
    # nerd-fonts-jetbrains-mono



# pacman

    # noto-fonts Noto Sans, Noto Serif
    # noto-fonts-cjk Noto Sans CJK SC, Noto Serif CJK SC
    # noto-fonts-emoji Emoji

	# 	options+=("ttf-roboto-mono" "" on)	
	# options+=("ttf-roboto" "" on)	


# 	ttf-sarasa-gothic

## 登陆 polkit-gnome

txtconfig="Desktop Config"

txtinstalldesktopenvironment="Install Desktop environment"


txtoverwrightcommondotfiles="Common dotfiles"
txtoverwrightdwmdotfiles="Dwm dotfiles"
txtoverwrightgnomedotfiles="Gnome dotfiles"

txtinstallparu="Install paru"
txtconfiggit="Config git"
txtconfiggitname="Config git username"
txtconfiggitmail="Config git mail"
txtinstallzsh="Install zsh"
txtinstallthemes="Install themes"
txtinstallfonts="Install fonts"

txtinstalldesktop="Install desktop environment"
txtinstalldesktopmenu="Install desktop menu"

txtinstalldwm="Install dwm"
txtinstallsoftwares="Install softwares"

configmenu() {
    if [ "${1}" = "" ]; then
		nextitem="."
	else
		nextitem=${1}
	fi

    options=()
	options+=("${txtoverwrightcommondotfiles}" "")
	options+=("${txtoverwrightdwmdotfiles}" "")
	options+=("${txtoverwrightgnomedotfiles}" "")

    sel=$(whiptail --backtitle "${apptitle}" --title "${txtconfig}" --menu "" --cancel-button "${txtexit}" --default-item "${nextitem}" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
    if [ "$?" = "0" ]; then
		case ${sel} in
            "${txtoverwrightcommondotfiles}")
				clear
				overwrightdotfiles common
				pressanykey
				nextitem="${txtoverwrightcommondotfiles}"
				
			;;
            "${txtoverwrightdwmdotfiles}")
				clear
				overwrightdotfiles dwm
				pressanykey
				nextitem="${txtoverwrightdwmdotfiles}"
			;;
            "${txtoverwrightgnomedotfiles}")
				clear
				overwrightdotfiles gnome
				pressanykey
				nextitem="${txtoverwrightgnomedotfiles}"
			;;
        esac
		configmenu "${nextitem}"
	fi
}

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
    options+=("${txtinstallthemes}" "")
    options+=("${txtinstallfonts}" "")
    options+=("${txtinstalldesktop}" "")
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
				nextitem="${txtinstallthemes}"
			;;

			 "${txtinstallthemes}")
				installthemes
				nextitem="${txtinstallfonts}"
			;;
			"${txtinstallfonts}")
				installfontsmenu
				nextitem="${txtinstalldesktop}"
			;;

			"${txtinstalldesktop}")
				installdesktopmenu
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
	if [ -d "$REPODIR/paru" ]; then
		rm -rf $REPODIR/paru
		tip "rm $REPODIR/paru"
	fi
    mkdir -p $REPODIR
    cd $REPODIR
    git clone https://aur.archlinux.org/paru.git $REPODIR/paru
    cd $REPODIR/paru
    makepkg -si
    paru -Syy   

    which paru
    pressanykey
}


overwrightdotfiles() {
	

	tip "cp -avf ${PWDIR}/dotfiles/${1:-common}/users/. ~/"
    cp -avf $PWDIR/dotfiles/${1:-common}/users/. ~/ 

	tip "sudo cp -avf $PWDIR/dotfiles/${1:-common}/root/. /"
    sudo cp -avf $PWDIR/dotfiles/${1:-common}/root/. /
	xrdb ~/.Xresources
	xrdb -merge ~/.config/X11/Xresources/nord-dark
	
	sudo systemctl enable fstrim.timer
	
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
    # cp ${PWDIR}/dotfiles/init/.zshrc ~/.zshrc
    # cat ${HOME}/.zshrc
    pressanykey
}

installthemes() {
	options=()
	options+=("mint" "" on)
    options+=("arc" "" off)	
    options+=("papirus" "" off)		
	options+=("breeze" "" off)	
	options+=("orchis" "" off)	
	options+=("nordic" "" off)
	options+=("qogir" "" off)

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

installfontsmenu() {
          	  
    options=()
 
    options+=("noto-fonts" "" on)	
	options+=("noto-fonts-cjk" "" on)
	options+=("noto-fonts-emoji" "" on)
	options+=("ttf-roboto-mono" "" on)	
	options+=("ttf-roboto" "" on)		
	options+=("ttf-joypixels" "" on)	
	options+=("ttf-sarasa-gothic" "" on)	


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
	options+=("ttf-symbola" "" on)
    options+=("nerd-fonts-ibm-plex-mono" "" on)	
    options+=("nerd-fonts-fira-code" "" on)	
    options+=("nerd-fonts-jetbrains-mono" "" on)	
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


  
}


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

    sel=$(whiptail --backtitle "${apptitle}" --title "${txtinstalldesktopmenu}" --menu "" --cancel-button "${txtexit}" --default-item "${nextitem}" 0 0 0 \
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
				installgnomemenu
                pressanykey
				nextitem="${txtinstallgnome}"
			;;
			"${txtinstallkde}")
				installkde
                pressanykey
				nextitem="${txtinstallkde}"
			;;
			"${txtinstallxfce}")
				installxfce
                pressanykey
				nextitem="${txtinstallxfce}"
			;;
			"${txtinstalllxqt}")
				installlxqt
				pressanykey
				nextitem="${txtinstalllxqt}"
			;;
        esac
		installdesktopmenu "${nextitem}"
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
    if [ -n "${pacmanpkgs}" ]; then
        tip "pacman -S ${pacmanpkgs}"
        sudo pacman -S --noconfirm ${pacmanpkgs}
        pressanykey
    fi

    if [ -n "${parupkgs}" ]; then
        tip "paru -S ${parupkgs}"
        paru -S --noconfirm ${parupkgs}
        pressanykey
    fi

   
    if [ "$configmpv" = 1 ]; then
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

    if [ "$configvm" = 1 ]; then
        tip "Config vm"
        sudo systemctl enable libvirtd
        sudo usermod -aG libvirt $USERNAME 
		sudo echo "tun" | sudo tee /etc/modules-load.d/tun.conf
        id
        pressanykey
    fi
}