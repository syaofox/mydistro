txtinstallkde="Install kde"

installkde() {
    clear
    tip "pacman -S xorg sddm plasma kde-applications"
    sudo pacman -S --noconfirm xorg sddm plasma kde-applications
    sudo systemctl enable sddm
    pressanykey
}