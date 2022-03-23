#!/usr/bin/env bash
set -e
PWDIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# cp /etc/X11/xinit/xinitrc ~/.xinitrc
# sed -i "/^twm &/d" ~/.xinitrc
# sed -i "/^xclock -geometry 50x50-1+1 &/d" ~/.xinitrc
# sed -i "/^xterm -geometry 80x50+494+51 &/d" ~/.xinitrc
# sed -i "/^xterm -geometry 80x20+494-0 &/d" ~/.xinitrc
# sed -i "/^exec xterm -geometry 80x66+0+0 -name login/d" ~/.xinitrc 
# cat  ${PWDIR}/dotfiles/init/.xinitrc >> ~/.xinitrc

# cp -r ${PWDIR}/dotfiles/.dwm ~/

sudo cp -r $PWDIR/bin/* /usr/local/bin/
sudo chmod +x /usr/local/bin/dmenu-websearch
sudo chmod +x /usr/local/bin/dm-kill
sudo chmod +x /usr/local/bin/dm-mount
sudo chmod +x /usr/local/bin/dm-power
sudo chmod +x /usr/local/bin/dm-theme
sudo chmod +x /usr/local/bin/fftovr
sudo chmod +x /usr/local/bin/mangaman
sudo chmod +x /usr/local/bin/metainfo
sudo chmod +x /usr/local/bin/sb-date   

sudo cp -r $PWDIR/applications/* /usr/share/applications
ls /usr/share/applications/dm-power.desktop
ls /usr/share/applications/dm-theme.desktop
ls /usr/share/applications/dm-mount.desktop

echo done!