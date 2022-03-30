export RANGER_LOAD_DEFAULT_RC=FALSE

export TERMINAL="st"
export EDITOR="nvim"
export VISUAL="nvim"

export PATH="$PATH:$HOME/.local/bin"
export QT_QPA_PLATFORMTHEME="qt5ct"

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec startx
fi