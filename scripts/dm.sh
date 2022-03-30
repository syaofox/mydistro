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

txtinstalldesktop="Install desktop environment"
txtinstalldesktopmenu="Install desktop menu"

txtinstalldwm="Install dwm"


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
				overwrightdotfiles common
				nextitem="${txtoverwrightcommondotfiles}"
			;;
            "${txtoverwrightdwmdotfiles}")
				overwrightdotfiles dwm
				nextitem="${txtoverwrightdwmdotfiles}"
			;;
            "${txtoverwrightgnomedotfiles}")
				overwrightdotfiles gnome
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
    options+=("${txtinstalldesktop}" "")

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
        esac
		desktopmenu "${nextitem}"
	fi
}

installparu() {
    clear   
    tip "Install Paru ${REPODIR}"
	if [ -d "$REPODIR/paru" ]; then
		rm -r $REPODIR/paru
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
	clear

	tip "cp -avf ${PWDIR}/dotfiles/${1:-common}/users/. ~/"
    cp -avf $PWDIR/dotfiles/${1:-common}/users/. ~/ 

	tip "sudo cp -avf $PWDIR/dotfiles/${1:-common}/root/. /"
    sudo cp -avf $PWDIR/dotfiles/${1:-common}/root/. /
	xrdb ~/.Xresources
	xrdb -merge ~/.config/X11/Xresources/nord 
	
	pressanykey
}

overwrightcommondotfiles(){
    clear
    overwrightdotfiles common
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


installdesktopmenu() {
    if [ "${1}" = "" ]; then
		nextitem="."
	else
		nextitem=${1}
	fi

    options=()
	options+=("${txtinstalldwm}" "")

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
        esac
		installdesktopmenu "${nextitem}"
	fi

}