# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

# Set path if required
#export PATH=$GOPATH/bin:/usr/local/go/bin:$PATH

# export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Fix Home,End and Del keys
bindkey "^[[H" beginning-of-line
bindkey "^[[4~" end-of-line
# cat后测试按键
bindkey "^[[P" delete-char

# Aliases
alias ls='ls --color=auto'
alias ll='ls -hl --color=auto'
alias la='ls -hla --color=auto'

# alias poweroff='umount /mnt/shares/dnas ; umount /mnt/shares/dnas_home ; umount /mnt/shares/downs ; sudo /usr/bin/poweroff'
# alias reboot='umount /mnt/shares/dnas ; umount /mnt/shares/dnas_home ; umount /mnt/shares/downs ; sudo /usr/bin/reboot'

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'


alias fehp='feh --recursive --action "rm '%f'" .'

# alias ec="$EDITOR $HOME/.zshrc" # edit .zshrc
# alias sc="source $HOME/.zshrc"  # reload zsh configuration

# Set up the prompt - if you load Theme with zplugin as in this example, this will be overriden by the Theme. If you comment out the Theme in zplugins, this will be loaded.
# autoload -Uz promptinit
# promptinit
# prompt adam1            # see Zsh Prompt Theme below

autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# Use vi keybindings even if our EDITOR is set to vi
bindkey -e

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
zplug "romkatv/powerlevel10k", as:theme, depth:1


# zplug - install/load new plugins when zsh is started or reloaded
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
zplug load #--verbose
