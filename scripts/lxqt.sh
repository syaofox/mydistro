txtinstalllxqt="Install lxqt"

installlxqt() {
    clear
    tip "sudo pacman -S --noconfirm lxqt lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings ffmpegthumbnailer"
    sudo pacman -S --noconfirm xorg lxqt lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings ffmpegthumbnailer
    sudo systemctl enable lightdm
    pressanykey
}