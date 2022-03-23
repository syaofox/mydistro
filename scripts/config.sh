
switchtochroot() {
	clear
	mkdir -p /mnt/root/mydistro
	cp -r ${PWDIR} /mnt/root
    ls /mnt/root/
    pressanykey
	arch-chroot /mnt /root/mydistro/install.sh --chroot config
}


sethostname() {
	hostname=$(whiptail --backtitle "${apptitle}" --title "${txtsethostname}" --inputbox "" 0 0 "${HOSTNAME}" 3>&1 1>&2 2>&3)
	if [ "$?" = "0" ]; then
		clear
		tip "echo \"${hostname}\" > /etc/hostname"
		echo "${hostname}" > /etc/hostname
		cat /etc/hostname
		pressanykey


       

        tip "Set hosts"
        sed -i "/^127.0.0.1 localhost/d" /etc/hosts
        sed -i "/^::1       localhost/d" /etc/hosts
        sed -i "/^127.0.1.1 ${hostname}.localdomain ${hostname}/d" /etc/hosts
        echo "127.0.0.1 localhost" >> /etc/hosts
        echo "::1       localhost" >> /etc/hosts
        echo "127.0.1.1 ${hostname}.localdomain ${hostname}" >> /etc/hosts 
        cat /etc/hosts
        pressanykey
	fi
}
setlocaltime() {
    
    clear
    tip "Create localtime..."
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    hwclock --systohc --utc
    date +"%Z%z"
    pressanykey
    
}




setlocale(){
	options=()
	defsel="en_US"
    options+=("zh_CN" "")
    options+=("en_US" "")

	locale=$(whiptail --backtitle "${apptitle}" --title "${txtsetlanguage}" --menu "" --default-item "${defsel}" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ "$?" = "0" ]; then
		clear
		echo "LANG=${locale}.UTF-8" > /etc/locale.conf      
		echo "LC_COLLATE=C" >> /etc/locale.conf
        cat /etc/locale.conf
        pressanykey 
		sed -i '/#'${locale}'.UTF-8/s/^#//g' /etc/locale.gen
        sed -i '/#zh_CN.UTF-8/s/^#//g' /etc/locale.gen
        sed -i '/#en_US.UTF-8/s/^#//g' /etc/locale.gen
        locale-gen
		pressanykey       
	fi


}


setrootpasswordchroot(){
    clear
	tip "passwd root"
	passed=1
	while [[ ${passed} != 0 ]]; do
		passwd root
		passed=$?
	done
	
}
adduser() {
    USERNAME=$(whiptail --backtitle "${apptitle}" --title "${txtadduser}" --inputbox "" 0 0 "${USERNAME}" 3>&1 1>&2 2>&3)
	if [ "$?" = "0" ]; then
		clear
		
       
        tip "Set ${USERNAME} ..."
        useradd -m $USERNAME
        
        passed=1
        while [[ ${passed} != 0 ]]; do
            passwd $USERNAME
            passed=$?
        done

        echo "${USERNAME} ALL=(ALL) ALL" > /etc/sudoers.d/$USERNAME
        usermod -aG wheel,power,users,storage,lp,adm,optical,audio,video,input $USERNAME    

        mkdir -p /home/${USERNAME}/Repos
        cp -r ${PWDIR} /home/${USERNAME}/Repos/
        chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/Repos/
        ls /home/${USERNAME} -la

        id $USERNAME
        pressanykey
	fi
}

installvideodrivers() {
    options=()
	defsel="AMD"
    options+=("INTEL" "")
    options+=("AMD" "")
    options+=("NVDIA" "")
    options+=("VM" "")

	PLATFORM=$(whiptail --backtitle "${apptitle}" --title "${txtselectvideodriver}" --menu "" --default-item "${defsel}" 0 0 0 \
		"${options[@]}" \
		3>&1 1>&2 2>&3)
	if [ "$?" = "0" ]; then
        clear
		case ${PLATFORM} in
            "AMD" )
                pacman -S --noconfirm xf86-video-amdgpu mesa vulkan-radeon
            ;;
            "INTEL" )
                pacman -S --noconfirm xf86-video-intel mesa vulkan-radeon
            ;;
            "NVDIA" )
                pacman -S --noconfirm nvidia nvidia-utils nvidia-settings
            ;;
            "VM" )
                pacman -S --noconfirm xf86-video-vmware
            ;;
            *)
                ptip "Cant't find platform: ${PLATFORM}"
            ;;
        esac
        pressanykey    
	fi  
}


installnetwork() {
    clear
    tip "Install networkmanager..."
    pacman -S --noconfirm networkmanager network-manager-applet dialog wpa_supplicant avahi inetutils dnsutils nss-mdns  
    systemctl enable NetworkManager
    systemctl enable avahi-daemon
    pressanykey
}

installsoundandblooth() {
    clear
    tip "Install sound & bluetooth..."
    pacman -S --noconfirm bluez bluez-utils alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack pavucontrol pamixer
    systemctl enable bluetooth 
    pressanykey
}

installutils() {
    clear
    tip "Install sound & bluetooth..."
    pacman -S --noconfirm gvfs gvfs-smb nfs-utils ntfs-3g bash-completion xdg-user-dirs xdg-utils python-pip acpi acpi_call tlp acpid
    systemctl enable acpid
    pacman -S --noconfirm openssh rsync reflector neofetch curl wget htop youtube-dl aria2 neovim
    ln /bin/nvim /bin/vi
    systemctl enable sshd 
    pressanykey
}

configsamba() {
    clear

    mkdir -p /mnt/shares/dnas
    mkdir -p /mnt/shares/dnas_home
    mkdir -p /mnt/shares/downs

    chown -R ${USERNAME}:${USERNAME} /mnt/shares

    echo "# samba set" >> /etc/fstab
    echo "//dnas/dnas /mnt/shares/dnas cifs _netdev,nofail,username=me,password=0928,uid=1000,gid=1000,workgroup=workgroup,vers=3.0,noauto,user 0 0" >> /etc/fstab
    echo "//dnas/dnas_home /mnt/shares/dnas_home cifs _netdev,nofail,username=me,password=0928,uid=1000,gid=1000,workgroup=workgroup,vers=3.0,noauto,user 0 0" >> /etc/fstab
    echo "//dnas/downs /mnt/shares/downs cifs _netdev,nofail,username=me,password=0928,uid=1000,gid=1000,workgroup=workgroup,vers=3.0,noauto,user 0 0" >> /etc/fstab
    
    ls /mnt/shares -l
    cat /etc/fstab

    pressanykey
}

installgrub() {
    clear
    pacman -S --noconfirm grub efibootmgr mtools dosfstools os-prober
    sed -i 's/#\(GRUB_DISABLE_OS_PROBER=false\)/\1/' /etc/default/grub
    tail -n 3 /etc/default/grub    
    grub-install --target=x86_64-efi --bootloader-id=ARCH --recheck
    grub-mkconfig -o /boot/grub/grub.cfg
    ls /boot/efi -la
    pressanykey
}

