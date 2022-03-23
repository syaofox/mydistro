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
eval "$(dbus-launch --sh-syntax --exit-with-session)" &

# see https://wiki.archlinux.org/title/GNOME/Keyring#xinitrc
source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh

# see https://wiki.archlinux.org/title/GNOME/Keyring#xinitrc
eval $(/usr/bin/gnome-keyring-daemon --start)
export SSH_AUTH_SOCK

# see https://github.com/NixOS/nixpkgs/issues/14966#issuecomment-520083836
mkdir -p "$HOME"/.local/share/keyrings


feh --bg-fill ~/Pictures/gallery/wallpapers/16x10/eva.jpg ~/Pictures/gallery/wallpapers/21x9/yuki.jpg

/bin/bash ~/.dwm/tap-to-click.sh
numlockx &
exec dwm
