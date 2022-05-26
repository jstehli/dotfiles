#          _
#  _______| |__  _ __ ___
# |_  / __| '_ \| '__/ __|
#  / /\__ \ | | | | | (__
# /___|___/_| |_|_|  \___|



# *** ALIASES ***

if [ -f ~/.aliases ]; then
    . ~/.aliases
fi


# *** HISTORY ***

HISTFILE=~/.cache/zsh/histfile
HISTSIZE=5000
SAVEHIST=10000


# *** KEYBINDINGS ***

# vim mode
bindkey -v

# make home/end/delete etc work
bindkey "^[[2~" quoted-insert
bindkey "^[[3~" delete-char
bindkey "^[[5~" beginning-of-history
bindkey "^[[6~" end-of-history
bindkey "^[[7~" beginning-of-line
bindkey "^[[8~" end-of-line


# *** COMMAND COMPLETION ***

autoload -Uz compinit
compinit
zstyle ':completion:*' menu select  # press Tab twice for an autocompletion menu
setopt COMPLETE_ALIASES  # autocompletion of command line switches for aliases
zstyle ':completion::complete:*' gain-privileges 1  # autocompletion in privileged cmd's, e.g., sudo


# *** PROMPT ***

# set prompt
PS1="[%n@%m %1~]%(#.#.$) "

# enable themes
autoload -Uz promptinit
promptinit


# *** DON'T OVERWRITE EXISTING FILES WHEN OUTPUTTING TO FILE ***

set -C



# *** ENABLE COLORS ***

autoload -U colors && colors




#  other stuff / todo.. :)

unsetopt beep
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/jonas/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall


alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

# ssh-agent to authenticate, e.g., to github
if ! pgrep -u "$USER" ssh-agent >> /dev//null; then
    ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [[ ! "$SSH_AUTH_SOCK" ]]; then
    source "$XDG_RUNTIME_DIR/ssh-agent.env" > /dev/null
fi
