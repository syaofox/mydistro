txtinstallxfce="Install xfce"

installxfce() {
    clear
    tip "${txtinstallxfce}"
    sudo pacman -S --noconfirm xorg lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings xfce4 xfce4-goodies 
    sudo systemctl enable lightdm
    pressanykey
}
