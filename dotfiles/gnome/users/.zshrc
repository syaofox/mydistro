# Use vi keybindings even if our EDITOR is set to vi
bindkey -e

# Fix Home,End and Del keys
bindkey "^[[H" beginning-of-line
bindkey "^[[4~" end-of-line
# cat后测试按键
# bindkey "^[[P" delete-char
bindkey "^[[3~" delete-char
# Aliases
alias ls='ls --color=auto'
alias ll='ls -hl --color=auto'
alias la='ls -hla --color=auto'

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'


alias fehp='feh --recursive --action "rm '%f'" .'

autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.



setopt histignorealldups sharehistory

# Keep 5000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=5000
SAVEHIST=5000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Use lf to switch directories and bind it to ctrl-o
rangercd () {
    tmp="$(mktemp)"
    ranger --choosedir="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"                                               
    fi
}
bindkey -s '^o' 'rangercd\n'

# youtube-dl with aria2c
function ytd() {
  youtube-dl $1 --external-downloader aria2c --external-downloader-args "-x16 -k 1M"
}

function tomp4 {
  filename="${1##*/}"
  extension="${filename##*.}"
  filename="${filename%.*}"
  ffmpeg -i $1 -c:v libx264 -preset medium -crf ${2:-18} -c:a aac "$filename.mp4"
}

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# zplug - manage plugins
source /usr/share/zsh/scripts/zplug/init.zsh
# zplug "plugins/git", from:oh-my-zsh
# zplug "plugins/sudo", from:oh-my-zsh
# zplug "plugins/command-not-found", from:oh-my-zsh
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-completions"
zplug "junegunn/fzf"
# zplug "themes/robbyrussell", from:oh-my-zsh, as:theme   # Theme
# zplug "romkatv/powerlevel10k", as:theme, depth:1
zplug "woefe/git-prompt.zsh"

# zplug - install/load new plugins when zsh is started or reloaded
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
zplug load # --verbose
