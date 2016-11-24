#!/usr/bin/env zsh

export USER="$(id -un)"
export GROUP="$(id -gn ${USER})"

if [ "$(hostname -f | cut -d'.' -f2,3)" = '42.fr' ]; then
    export AT_42=true
    export FULLNAME="$(id -F)"
    export MAIL="${USER}@student.42.fr"
else
    if [ $# -eq 2 ]; then
        FULLNAME=$1
        MAIL=$2
    else
        echo 'Full name:'
        read FULLNAME
        echo 'Email:'
        read MAIL
    fi
    export FULLNAME
    export MAIL
fi

if [ ${AT_42} ]; then
    export HOMEBREW_CACHE="${HOME}/.tmp/brew_cache"
fi

# NodeJs
if [ "${USER}" != 'root' ]; then
    export NPM_PACKAGES=${HOME}/.npm-packages
    export NODE_PATH="${NPM_PACKAGES}/lib/node_modules:${NODE_PATH}"
fi

if [ ${AT_42} ]; then
    PATH="${HOME}/.brew/bin:${NPM_PACKAGES}/bin:${HOME}/.meteor:/usr/local/munki:/opt/X11/bin"
else
    PATH="${HOME}/bin:${NPM_PACKAGES}/bin:${HOME}/.meteor"
fi
export PATH="${PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
#export MANPATH="${MANPATH}"

if [ -z "$(git config --global user.name)" ]; then
    git config --global user.name "${FULLNAME}"
fi
if [ -z "$(git config --global user.email)" ]; then
    git config --global user.email "${MAIL}"
fi
if [ -z "$(git config --global core.excludesfile)" ]; then
    git config --global core.excludesfile "${HOME}/.gitignore_global"
fi
if [ -z "$(git config --global push.default)" ]; then
    git config --global push.default 'simple'
fi
#if [ -z "$(git config --global diff.tool)" ]; then
#    git config --global diff.tool vimdiff
#fi
#if [ -z "$(git config --global difftool.prompt)" ]; then
#    git config --global difftool.prompt false
#fi
#if [ -z "$(git config --global alias.df)" ]; then
#    git config --global alias.df diff
#fi
#if [ -z "$(git config --global alias.dt)" ]; then
#    git config --global alias.dt difftool
#fi

mkdir -p "${HOME}/.tmp/nvim"
if [ ${AT_42} ]; then
    mkdir -p "${HOMEBREW_CACHE}"
fi

if [ -n $(whence nvim 2>/dev/null) ]; then
    VIMRC='.config/nvim/init.vim'
else
    VIMRC='.vimrc'
fi
if [ "${SHELL}" = 'zsh' ]; then
    SHRC='.zshrc'
else
    SHRC='.bashrc'
    INPUTRC='.inputrc'
fi
for f in "${SHRC}" "${VIMRC}" ${INPUTRC} '.config/agrc' '.config/redshift.conf' '.inputrc' '.gitignore_global' '.gdbinit' '.lldbinit'; do
    if [ ! -f "${HOME}/${f}" ]; then
        curl -fLo "${HOME}/${f}" --create-dirs "https://raw.githubusercontent.com/pandark/setup_42/master/.dotfiles/${f}"
    fi
done

sed -i '' "s/mail_placeholder/${MAIL}/;s/fullname_placeholder/${FULLNAME}/" "${SHRC}"

if [ ${AT_42} ]; then
    if [ -d "${HOME}/.brew" ]; then
        mkdir ${HOME}/.brew && \
            curl -L https://github.com/Homebrew/homebrew/tarball/master | \
            tar xz --strip 1 -C ${HOME}/.brew
        brew update
        brew upgrade
    fi

    if [ ! -f "${HOME}/.brew/share/zsh/site-functions/_brew" ] ; then
        curl -Lo "${HOME}/.brew/share/zsh/site-functions/_brew" https://raw.githubusercontent.com/Homebrew/homebrew/master/Library/Contributions/brew_zsh_completion.zsh
    fi

    if [ -z "$(brew list | grep -w neovim)" ]; then
        brew tap neovim/neovim
        brew install --HEAD neovim
    fi

    for software in 'tree' 'pstree' 'the_silver_searcher' 'htop-osx' 'wget' 'valgrind' 'ranger' 'redshift' 'node' 'python' 'python3'; do
        if [ -z "$(brew list | grep -w ${software})" ]; then
            brew install ${software}
        fi
    done
fi

if [ ${AT_42} -o "${USER}" = 'root' ]; then
    for software in 'eslint' 'jshint'; do
        if [ -z "$(npm install -g | grep -w ${software})" ]; then
            npm install -g ${software}
        fi
    done
fi

if [ -n "$(whence nvim 2>/dev/null)" ]; then
    curl -fLo ${HOME}/.config/nvim/autoload/plug.vim \
        --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    nvim +PlugInstall +qall
else
    curl -fLo ${HOME}/.vim/autoload/plug.vim \
        --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    vim +PlugInstall +qall
fi

if [ "${USER}" != 'root' -a -n "$(whence npm)" ]; then
    npm config set prefix "${HOME}/.npm-packages"
fi
