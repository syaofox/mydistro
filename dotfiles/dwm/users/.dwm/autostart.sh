#!/usr/bin/env bash

mon1=eDP
mon2=DisplayPort-0
# wait 3
if xrandr | grep "$mon2 disconnected"; then
    xrandr --output "$mon2" --off --output "$mon1" --auto
elif xrandr | grep "$mon1 disconnected"; then
    xrandr --output "$mon1" --off --output "$mon2" --auto
else
    xrandr --output "$mon1" --primary --auto --output "$mon2" --above "$mon1" --auto
fi

/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
# eval "$(dbus-launch --sh-syntax --exit-with-session)" &

# # see https://wiki.archlinux.org/title/GNOME/Keyring#xinitrc
# source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh

# # see https://wiki.archlinux.org/title/GNOME/Keyring#xinitrc
# eval $(/usr/bin/gnome-keyring-daemon --start)
# export SSH_AUTH_SOCK

# # see https://github.com/NixOS/nixpkgs/issues/14966#issuecomment-520083836
# mkdir -p "$HOME"/.local/share/keyrings

xautolock -time 10 -locker '/usr/local/bin/slock' -corners ---- -cornersize 30 &
/bin/bash ~/.fehbg

if [[ ! $(pgrep picom) ]]; then
        exec picom --experimental-backends -b &
fi

arr=("xfce4-power-manager" "fcitx5" "dwmblocks")

for value in ${arr[@]}; do
    if [[ ! $(pgrep ${value}) ]]; then
        exec "$value" &
    fi
done

/bin/bash ~/.dwm/tap-to-click.sh
numlockx &

# if [[ ! $(pgrep xob) ]]; then
#     exec "sxob"
# fi


# function run {
#  if ! pgrep $1 ;
#   then
#     $@&
#   fi
# }
# xfconf-query -c xfce4-session -p /general/LockCommand -s "slock"
# run "picom --experimental-backends -b"
# run "slstatus"
# run "xfce4-power-manager"
# run "fcitx5"
# run "nm-applet"
# run "blueberry-tray"
# run "parcellite"


# sleep 1s
# pactl set-sink-mute @DEFAULT_SINK@ 0
# pactl set-sink-volume @DEFAULT_SINK@ 100%
# sleep 1s
# mpv ~/.dwm/click.mp3
# run "volumeicon"


# killall -q tap-to-click.sh
# while pgrep -u $UID -x tap-to-click.sh >/dev/null; do sleep 1; done
# /bin/bash ~/.dwm/tap-to-click.sh

# mountpoint -q /mnt/shares/dnas/dnas && echo "mounted" || echo "not mounted" 

# if ! mountpoint -q /mnt/shares/dnas ; then mount /mnt/shares/dnas; fi
# if ! mountpoint -q /mnt/shares/dnas_home ; then mount /mnt/shares/dnas_home; fi
# if ! mountpoint -q /mnt/shares/downs ; then mount /mnt/shares/downs; fi


