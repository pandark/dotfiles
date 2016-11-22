# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

if [ "$(hostname -f | cut -d'.' -f2,3)" = "42.fr" ]; then
    export AT_42=true
fi

######################
#        USER        #
######################

export USER="$(id -un)"
export GROUP=$(id -gn $USER)
if [ ! ${AT_42} ]; then
    export FULLNAME="fullname_placeholder"
    export MAIL="mail_placeholder"
else
    export FULLNAME="$(id -F)"
    export MAIL="$USER@student.42.fr"
fi

######################
#        PATHS       #
######################

if [ ${AT_42} ]; then
    export HOMEBREW_CACHE="${HOME}/.tmp/brew_cache"
fi

# NodeJs
if [ "${USER}" != "root" ]; then
    export NPM_PACKAGES=${HOME}/.npm-packages
    export NODE_PATH="${NPM_PACKAGES}/lib/node_modules:${NODE_PATH}"
fi

if [ ${AT_42} ]; then
    PATH="${HOME}/.brew/bin:${NPM_PACKAGES}/bin:${HOME}/.meteor:/usr/local/munki:/opt/X11/bin"
else
    PATH="${HOME}/bin:${NPM_PACKAGES}/bin:${HOME}/.meteor"
fi
export PATH="$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
#export MANPATH="${MANPATH}"

if  [ -n "$(type nvim 2>/dev/null)" ] ; then
    export VI='nvim'
else
    export VI='vim'
fi

export EDITOR="${VI}"

######################
#      CONF BASH     #
######################

set -o emacs # vim rocks but bash vim-bindings suck

# bash history
HISTSIZE=10000
HISTFILESIZE=10000
shopt -s histappend
# ignore duplicate lines and lines starting with a space
HISTCONTROL=ignoredups:ignorespace
#HISTIGNORE='&:exit:fg:fc:history:l:ls:ll:cd ..:cd:cd ~:cd -:~:-:..'

# enable programmable completion features
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    source /etc/bash_completion
fi
if [ -f /usr/lib/node_modules/npm/lib/utils/completion.sh ]; then
    source /usr/lib/node_modules/npm/lib/utils/completion.sh
fi

# make cd implicit to move into directories
shopt -s autocd

# pattern "**"  match all files and zero or more (sub)directories
shopt -s globstar

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# prevent ^S and ^Q doing XON/XOFF (mostly for Vim)
stty -ixon

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
#    PROMPT BASH     #
######################

# https://github.com/gpoulter/shellfiles/blob/master/bash/prompt
## Print nickname for git/hg/bzr/svn version control in CWD
## Optional $1 of format string for printf, default "(%s) "
function __vcs_info
{
    local dir="$PWD"
    local vcs
    local nick
    while [[ "$dir" != "/" ]]; do
        for vcs in git hg svn bzr; do
            if [[ -d "$dir/.$vcs" ]] && hash "$vcs" &>/dev/null; then
                case "$vcs" in
                    git) __git_ps1 "${1:-(%s) }"; return;;
                    hg) nick=$(hg branch 2>/dev/null);;
                    svn) nick=$(svn info 2>/dev/null\
                        | grep -e '^Repository Root:'\
                        | sed -e 's#.*/##');;
                    bzr)
                        local conf="${dir}/.bzr/branch/branch.conf" # normal branch
                        [[ -f "$conf" ]] && nick=$(grep -E '^nickname =' "$conf" | cut -d' ' -f 3)
                        conf="${dir}/.bzr/branch/location" # colo/lightweight branch
                        [[ -z "$nick" ]] && [[ -f "$conf" ]] && nick="$(basename "$(< $conf)")"
                        [[ -z "$nick" ]] && nick="$(basename "$(readlink -f "$dir")")";;
                esac
                [[ -n "$nick" ]] && printf "${1:-(%s) }" "$nick"
                return 0
            fi
        done
        dir="$(dirname "$dir")"
    done
}

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

if [ "${USER}" = "root" ]; then
    PS_prompt="$ "
else
    PS_prompt="# "
fi
PS_time="\t" # like "%* but uses a leading zero when needed
PS_host="\h"
PS_user="\u"
PS_cwd="\w"

GIT_PS1_SHOWDIRTYSTATE=yes
GIT_PS1_SHOWSTASHSTATE=yes
GIT_PS1_SHOWUNTRACKEDFILES=yes
GIT_PS1_SHOWUPSTREAM=yes
PS_vcsinfo="\$(__vcs_info "$2")"

# comment this line for a distraction-free prompt
color_prompt=$COLOR_TERM
if [ "$color_prompt" ]; then
    PS_prompt="\[\033[01;37m\]$PS_prompt\[\033[00m\]"
    PS_host="\[\033[01;30m\]@$PS_host\[\033[00m\]"
    # time: color coded by last return code
    PS_time_success="\[\033[00\;32m\]\]$PS_time\[\033[00m\]"
    PS_time_failure="\[\033[00\;31m\]\]$PS_time\[\033[00m\]"
    PS_time="\`[ \$? = 0 ] && echo $PS_time_success || echo $PS_time_failure\`"
    # user: color coded by privileges
    if [ "${USER}" = "root" ]; then
        PS_user="\[\033[01;33m\]$PS_user\[\033[00m\]"
    else
        PS_user="\[\033[01;31m\]$PS_user\[\033[00m\]"
    fi
    PS_cwd="\[\033[01;34m\]$PS_cwd\[\033[00m\]"
    PS_vcsinfo="\[\033[00;33m\]$PS_vcsinfo\[\033[00m\]"
fi
unset color_prompt

# two-line prompt with time and current vcs branch
PS1="${PS_time} ${debian_chroot:+($debian_chroot)}${PS_user}$PS_host:${PS_cwd} ${PS_vcsinfo}\n${PS_prompt}"

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

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# VirtualenvWrapper
export WORKON_HOME="${HOME}/.envs"
if [ -f "${HOME}/.brew/bin/virtualenvwrapper.sh" ]; then
    source  "${HOME}/.brew/bin/virtualenvwrapper.sh"
fi

#######################
#   START PROGRAMS    #
#######################

if [ -n "$(type redshift 2>/dev/null)" -a -z "$(pgrep redshift)" ] ; then
    echo "launching redshift"
    nohup redshift 2>&1 >/dev/null &
    alias redshift_stop='kill $(pgrep redshift)'
fi

if [ ${AT_42} ]; then
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
