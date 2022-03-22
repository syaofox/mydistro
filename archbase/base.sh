#!/usr/bin/env bash
set -e

RED="\e[1;31m"
GREEN="\e[1;32m"
YELLOW="\e[3;33m"
BLUE="\e[3;34m"
GRAY="\e[3;37m"
ENDCOLOR="\e[0m"



HOSTNAME="arch"
PLATFORM="AMD"
USERNAME="syaofox"
PASSWORD="0928"
SWAPSIZE="17408"


GITNAME="syaofox"
GITMAIL="syaofox@gmail.com"

USERHOME="/home/${USERNAME}"
REPODIR="${USERHOME}/Repos"




tip() {
    echo -e "${GREEN}${1:-Done!}${ENDCOLOR}"
}

ptip() {
    read -p "$(echo -e $YELLOW${1:-Press enter to continue...}$ENDCOLOR)" temp
}

etip() {
    TIP="$($1)"
    echo -e "${GRAY}${TIP:-Done!}${ENDCOLOR}"
    read -p "$(echo -e $YELLOW${2:-Press enter to continue...}$ENDCOLOR)" temp
}

set_swap() {
    tip "$1"

    tip "Settting Swap..."
    dd if=/dev/zero of=/swapfile bs=1M count=${SWAPSIZE} status=progress
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    sed -i "/^swapfile/d" /etc/fstab
    echo "/swapfile none swap defaults 0 0" >> /etc/fstab
    etip "swapon -s"

    tip "Settting Swappiness..."
    echo "vm.swappiness=10" > /etc/sysctl.d/99-swappiness.conf
    sed -i '/^vm.swappiness=10/d' /etc/sysctl.d/99-swappiness.conf
    echo "vm.swappiness=10" >> /etc/sysctl.d/99-swappiness.conf
    etip "cat /etc/sysctl.d/99-swappiness.conf"
}

set_locale() {
    tip "$1"  

    tip "Create localtime..."
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    hwclock --systohc

    etip "date +\"%Z%z\""
    tip "Gen locale"
    sed -i 's/#\(en_US.UTF-8\)/\1/' /etc/locale.gen
    sed -i 's/#\(zh_CN.UTF-8\)/\1/' /etc/locale.gen
    locale-gen
    echo "LANG=en_US.UTF-8" > /etc/locale.conf    
    etip "cat /etc/locale.conf"

    tip "Set hostname"
    echo "${HOSTNAME}" > /etc/hostname
    etip "cat /etc/hostname"
    
    tip "Set hosts"
    sed -i "/^127.0.0.1 localhost/d" /etc/hosts
    sed -i "/^::1       localhost/d" /etc/hosts
    sed -i "/^127.0.1.1 ${HOSTNAME}.localdomain ${HOSTNAME}/d" /etc/hosts
    echo "127.0.0.1 localhost" >> /etc/hosts
    echo "::1       localhost" >> /etc/hosts
    echo "127.0.1.1 ${HOSTNAME}.localdomain ${HOSTNAME}" >> /etc/hosts 
    etip "cat /etc/hosts"

}

install_pkg() {
    tip "$1"
    pacman -Syy

    tip "Install Network"
    pacman -S networkmanager network-manager-applet dialog wpa_supplicant avahi inetutils dnsutils nss-mdns  
    systemctl enable NetworkManager
    systemctl enable avahi-daemon

    ptip "Press any key to start install ${PLATFORM} video drivers"
    case ${PLATFORM} in
        "AMD" )
            pacman -S xf86-video-amdgpu mesa vulkan-radeon
        ;;
        "INTEL" )
            pacman -S xf86-video-intel mesa vulkan-radeon
        ;;
        "NVDIA" )
            pacman -S nvidia nvidia-utils nvidia-settings
        ;;
        "VM" )
            pacman -S xf86-video-vmware
        ;;
        *)
            ptip "Cant't find platform: ${PLATFORM}"
        ;;
    esac    

    tip "Install sound & bluetooth"
    # pacman -S pulseaudio pulseaudio-bluetooth bluez bluez-utils alsa-utils pavucontrol pamixer
    pacman -S bluez bluez-utils alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack pavucontrol pamixer
    systemctl enable bluetooth 
    
    tip "Install utils"
    pacman -S gvfs gvfs-smb nfs-utils ntfs-3g bash-completion xdg-user-dirs xdg-utils python-pip 
    pacman -S acpi acpi_call tlp acpid
    systemctl enable acpid
    
    tip "Install Software"
    pacman -S openssh rsync reflector neofetch curl wget htop youtube-dl aria2 neovim
    ln /bin/nvim /bin/vi
    systemctl enable sshd 

    tip
}

set_users() {
    tip "$1"

    tip "Set root passwd $PASSWORD"
    echo root:${PASSWORD} | chpasswd
    echo "root passwd:${PASSWORD}"    

    tip "Set ${USERNAME} ..."
    useradd -m $USERNAME
    echo "${USERNAME}:${PASSWORD}" | chpasswd
    echo "${USERNAME} ALL=(ALL) ALL" > /etc/sudoers.d/$USERNAME
    usermod -aG wheel,power,users,storage,lp,adm,optical,audio,video $USERNAME    

    etip "id $USERNAME"    
}

set_smb() {

    tip "$1"

    mkdir -p /mnt/shares/dnas
    mkdir -p /mnt/shares/dnas_home
    mkdir -p /mnt/shares/downs

    chown -R ${USERNAME}:${USERNAME} /mnt/shares

    echo "# samba set" >> /etc/fstab
    echo "//dnas/dnas /mnt/shares/dnas cifs _netdev,nofail,username=me,password=0928,uid=1000,gid=1000,workgroup=workgroup,vers=3.0,noauto,user 0 0" >> /etc/fstab
    echo "//dnas/dnas_home /mnt/shares/dnas_home cifs _netdev,nofail,username=me,password=0928,uid=1000,gid=1000,workgroup=workgroup,vers=3.0,noauto,user 0 0" >> /etc/fstab
    echo "//dnas/downs /mnt/shares/downs cifs _netdev,nofail,username=me,password=0928,uid=1000,gid=1000,workgroup=workgroup,vers=3.0,noauto,user 0 0" >> /etc/fstab
    
    etip "ls /mnt/shares -l"
    etip "cat /etc/fstab"
}


config_archlinuxcn() {
    tip "$1"

    echo "[archlinuxcn]"  >> /etc/pacman.conf
    echo "Server = https://mirrors.bfsu.edu.cn/archlinuxcn/\$arch"  >> /etc/pacman.conf

    pacman -Syy
    pacman -S archlinuxcn-keyring 
    pacman -Syy   
   
    etip "tail -n 3 /etc/pacman.conf"
}


install_grub() {
 
    tip "$1"

    pacman -S grub efibootmgr mtools dosfstools os-prober
    sed -i 's/#\(GRUB_DISABLE_OS_PROBER=false\)/\1/' /etc/default/grub
    tail -n 3 /etc/default/grub
    
    grub-install --target=x86_64-efi --bootloader-id=ARCH --recheck
    grub-mkconfig -o /boot/grub/grub.cfg

    etip "ls /boot/efi -la"    
}


base_install() {
    set_swap "Setting Swap and Swappiness..."
    set_locale "Setting Locale...."
    install_pkg "Installing Packages..."
    set_users "Setting root password and new user..."
    set_smb "Setting smb..."
    # config_archlinuxcn "Setting Archilinuxcn..."
    install_grub "Installing grub"
}


