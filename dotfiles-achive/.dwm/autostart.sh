#!/usr/bin/env bash


function run {
 if ! pgrep $1 ;
  then
    $@&
  fi
}
xfconf-query -c xfce4-session -p /general/LockCommand -s "slock"
run "picom --experimental-backends -b"
run "slstatus"
run "xfce4-power-manager"
run "fcitx5"
run "nm-applet"
run "blueberry-tray"
run "parcellite"


# sleep 1s
# pactl set-sink-mute @DEFAULT_SINK@ 0
# pactl set-sink-volume @DEFAULT_SINK@ 100%
sleep 1s
mpv ~/.dwm/click.mp3
run "volumeicon"


# killall -q tap-to-click.sh
# while pgrep -u $UID -x tap-to-click.sh >/dev/null; do sleep 1; done
# /bin/bash ~/.dwm/tap-to-click.sh

# mountpoint -q /mnt/shares/dnas/dnas && echo "mounted" || echo "not mounted" 

# if ! mountpoint -q /mnt/shares/dnas ; then mount /mnt/shares/dnas; fi
# if ! mountpoint -q /mnt/shares/dnas_home ; then mount /mnt/shares/dnas_home; fi
# if ! mountpoint -q /mnt/shares/downs ; then mount /mnt/shares/downs; fi


