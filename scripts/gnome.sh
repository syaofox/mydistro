txtinstallgnome="Install gnome"

installgnomemenu() {
    clear

    tip "sudo pacman -S xorg gdm gnome gnome-extra firefox gnome-tweaks gnome-software-packagekit-plugin flatpak"
    sudo pacman -S --noconfirm xorg gdm gnome gnome-extra firefox gnome-tweaks gnome-software-packagekit-plugin flatpak
    sudo systemctl enable gdm
    tip "paru -S chrome-gnome-shell  gnome-terminal-transparency"
    paru -S --noconfirm chrome-gnome-shell  gnome-terminal-transparency gnome-software-packagekit-plugin

    pressanykey
}