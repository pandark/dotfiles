if [ "$(hostname -f | cut -d'.' -f2,3)" = "42.fr" ]; then
    export AT_42=true
fi

######################
#        USER        #
######################

export USER="$(id -un)"
export GROUP=$(id -gn $USER)
if [ ! $AT_42 ]; then
    export FULLNAME="fullname_placeholder"
    export MAIL="mail_placeholder"
else
    export FULLNAME="$(id -F)"
    export MAIL="$USER@student.42.fr"
fi

######################
#        PATHS       #
######################

if [ $AT_42 ]; then
    export HOMEBREW_CACHE="${HOME}/.tmp/brew_cache"
fi

# NodeJs
if [ "${USER}" != "root" ]; then
    export NPM_PACKAGES=${HOME}/.npm-packages
    export NODE_PATH="${NPM_PACKAGES}/lib/node_modules:${NODE_PATH}"
fi

if [ $AT_42 ]; then
    PATH="${HOME}/.brew/bin:${NPM_PACKAGES}/bin:${HOME}/.meteor:/usr/local/munki:/opt/X11/bin"
else
    PATH="${HOME}/bin:${NPM_PACKAGES}/bin:${HOME}/.meteor"
fi
export PATH="$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
#export MANPATH="${MANPATH}"

if  [ -n "$(whence nvim 2>/dev/null)" ] ; then
    export VI='nvim'
else
    export VI='vim'
fi

export EDITOR="${VI}"

######################
#      CONF ZSH      #
######################

bindkey -e # vim rocks but zsh vim-bindings suck

# zsh history
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups # ignore duplication command history list
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history # share command history data

# zsh completion
# better autocomplete
autoload -U compinit && compinit
# autocomplete menu
zstyle ':completion:*' menu select
# add completion provied by bin installed via brew
if [[ -d "${HOME}/.brew/share/zsh/site-functions" ]]; then
    fpath=(${HOME}/.brew/share/zsh/site-functions $fpath)
fi
if [ -f /usr/lib/node_modules/npm/lib/utils/completion.sh ]; then
    source /usr/lib/node_modules/npm/lib/utils/completion.sh
fi

# make cd implicit to move into directories
setopt auto_cd
# if a var contains a dirs, use this var name
setopt auto_name_dirs
# pushd instead of cd (unpile with popd)
setopt auto_pushd
setopt pushd_ignore_dups

# delete key
bindkey "\e[3~"   delete-char

# home / end
bindkey '\e[H' beginning-of-line
bindkey '\e[F' end-of-line

# search in history based on what is type
bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward

bindkey '^[[Z' reverse-menu-complete
bindkey ' ' magic-space  # also do history expansion on space

# ctrl + arrows
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# prompt color
autoload -U colors && colors

######################
#       ALIASES      #
######################

case "$TERM" in
    xterm*|rxvt*|screen|vt100)
        COLOR_TERM=$TERM;; # we know these terms have proper color support
    *)
        if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
            COLOR_TERM=$TERM # we seem to have color support:
            # assume it's compliant with ECMA-48 (ISO/IEC-6429)
        fi;;
esac

# enable color support for ls and grep when possible
if [ -n "$COLOR_TERM" ]; then
    alias grep='grep --color=auto'
    # find the option for using colors in ls: GNU or BSD version
    unalias ls 2>/dev/null
    ls --color -d . &>/dev/null 2>&1 \
        && alias ls='ls --group-directories-first --color=auto' \
        || alias ls='ls -G' # BSD
fi

# ls
unalias l 2>/dev/null
unalias ll 2>/dev/null
unalias la 2>/dev/null
unalias lah 2>/dev/null
unalias lh 2>/dev/null
alias l='ls -lA'
alias ll='ls -l'
alias la='ls -A'

alias tree='tree -a -I ".git|node_modules"'

alias vi="${VI}"
alias vim="${VI}"
alias vimdiff="${VI} -d"
alias view="${VI} -R"

# VirtualenvWrapper
alias mkvenv2='mkvirtualenv -p $(type -p python2)'
alias mkvenv3='mkvirtualenv -p $(type -p python3)'

# gcc
#alias gdb='lldb'
alias gg='gcc -Wall -Wextra -Werror'
alias g+='g++ -Wall -Wextra -Werror'

# git
alias ga='git add'
alias gu='git add -u'
alias gcm='git commit -m'
alias gbs='git status'
alias gb='git branch'
alias gl='git log --oneline'
alias gcb='git checkout -b'
alias gco='git checkout'
alias gch='git checkout'
alias gpl='git pull'
alias gps='git push'
alias gm='git merge'

# smart SSH agent: http://beyond-syntax.com/blog/2012/01/on-demand-ssh-add/
#       (see also: https://gist.github.com/1998129)
#alias ssh='( ssh-add -l > /dev/null || ssh-add ) && ssh'
#alias git-push='( ssh-add -l > /dev/null || ssh-add ) && git push'
#alias git-pull='( ssh-add -l > /dev/null || ssh-add ) && git pull'
#alias git-fetch='( ssh-add -l > /dev/null || ssh-add ) && git fetch'

alias weather='curl -s http://wttr.in/Paris | head -17'

# tmux with 256 colors
alias tmux="tmux -2"

# cleanup
alias vim_clean='find "${HOME}/.tmp/${VI}" -mindepth 1 -delete'
if [ "${USER}" != "root" ]; then
    alias npm_clean='find "${HOME}/.npm-packages" -mindepth 1 -delete'
fi

######################
#    PROMPT ZSH      #
######################

# version control
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git hg svn
zstyle ':vcs_info:*'  formats $PS_vcsinfo" [‡ %b]"
zstyle ':vcs_info:hg*'  formats $PS_vcsinfo" [☿ %b]"
zstyle ':vcs_info:git*' formats $PS_vcsinfo" [± %b]"
precmd() {
    vcs_info
}

# prompt parts
local PS_prompt="%# "
local PS_time="%D{%H:%M:%S}" # like "%* but uses a leading zero when needed
local PS_host="@$(hostname)"
local PS_user="%n$PS_host"
local PS_cwd="%~"
local PS_vcsinfo="%r/%S"

# comment this line for a distraction-free prompt
local color_prompt=$COLOR_TERM
if [ "$color_prompt" ]; then
    autoload colors && colors
    PS_prompt="%{$fg_bold[white]%}$PS_prompt%{$reset_color%}"
    PS_host="%{$fg_bold[green]%}$PS_host%{$reset_color%}"
    # time: color coded by last return code
    PS_time="%(?.%{$fg[green]%}.%{$fg[red]%})$PS_time%{$reset_color%}"
    # user: color coded by privileges
    PS_user="%(!.%{$fg_bold[red]%}.%{$fg_bold[green]%})$PS_user%{$reset_color%}"
    PS_cwd="%{$fg_bold[blue]%}$PS_cwd%{$reset_color%}"
    PS_vcsinfo="%{$fg[blue]%}$PS_vcsinfo%{$reset_color%}"
fi
unset color_prompt

# two-line prompt with time + current vcs branch on the right
setopt prompt_subst
RPROMPT='${vcs_info_msg_0_}'
PROMPT="${PS_time} ${PS_user}:${PS_cwd}
${PS_prompt}"

#######################
#    LS EN COULEUR    #
#######################

#a     black
#b     red
#c     green
#d     brown
#e     blue
#f     magenta
#g     cyan
#h     light grey
#A     bold black, usually shows up as dark grey
#B     bold red
#C     bold green
#D     bold brown, usually shows up as yellow
#E     bold blue
#F     bold magenta
#G     bold cyan
#H     bold light grey; looks like bright white
#x     default foreground or background

DIR="ex"
SYMLNK="gx"
SOCKET="xx"
PIPE="xx"
EXEC="cx"
BLCKSPE="xx"
CHARSPE="xx"
EXECSUID="cx"
EXECSGID="cx"
DIRWSB="ad"
DIRW="ad"
export LSCOLORS="$DIR$SYMLNK$SOCKET$PIPE$EXEC$BLCKSPE$CHARSPE$EXECSUID$EXECSGID$DIRWSB$DIRWd"

#######################
#    MAN EN COULEUR   #
#######################

man()
{
    env \
        LESS_TERMCAP_mb=$(printf "\e[1;31m") \
        LESS_TERMCAP_md=$(printf "\e[1;31m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
        man "$@"
}

######################
#   OTHER PROGRAMS   #
######################

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# VirtualenvWrapper
export WORKON_HOME="${HOME}/.envs"
if [ -f "${HOME}/.brew/bin/virtualenvwrapper.sh" ]; then
    source  "${HOME}/.brew/bin/virtualenvwrapper.sh"
fi

#######################
#   START PROGRAMS    #
#######################

if [ -n "$(whence redshift 2>/dev/null)" -a -z "$(pgrep redshift)" ] ; then
    echo "launching redshift"
    nohup redshift 2>&1 >/dev/null &
    alias redshift_stop='kill $(pgrep redshift)'
fi

if [ $AT_42 ]; then
    #######################
    #   EXERCICES AT 42   #
    #######################

    function next ()
    {
        nb=$(basename `pwd` | grep "ex")
        if [[ -n "$nb" ]]; then
            if [[ -n "$1" ]]; then inc=$1; else inc=1; fi
            nb=$(expr `echo $nb | tr -d "[a-z]"` + $inc)
            if [[ $nb -lt 10 ]] ; then
                dir="../ex0$nb"
            else
                dir="../ex$nb"
            fi
            mkdir -p $dir
            cd $dir
        fi
    }

    function prev ()
    {
        nb=$(basename `pwd` | grep "ex")
        if [[ -n "$nb" ]]; then
            if [[ -n "$1" ]]; then dec=$1; else dec=1; fi
            nb=$(expr `echo $nb | tr -d "[a-z]"` - $dec)
            if [[ $nb -lt 0 ]] ; then
                dir="../ex00"
            elif [[ $nb -lt 10 ]] ; then
                dir="../ex0$nb"
            else
                dir="../ex$nb"
            fi
            cd $dir
        fi
    }
fi
