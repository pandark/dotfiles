42 dotfiles
===========

## Install

* Clone the repo

``` sh
git clone https://github.com/pandark/dotfiles.git .dotfiles
```

* Checkout the 42 branch

``` sh
cd .dotfiles
git checkout 42
```

* Clone submodules

``` sh
git submodule init
git submodule update
```

* Create the symbolic links

``` sh
cd ..
rm -Rf .vim && rm -f .vimrc && rm -f .oh-my-zsh && rm -f .zshrc && rm -f .gdbinit
ln -s .dotfiles/.vim && ln -s .dotfiles/.vimrc && ln -s .dotfiles/.oh-my-zsh && ln -s .dotfiles/.zshrc && ln -s .dotfiles/.gdbinit
```
