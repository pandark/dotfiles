dotfiles
===========

## Install

* Clone the repo

``` sh
git clone https://github.com/pandark/dotfiles.git .dotfiles
cd .dotfiles
```

* Clone submodules

``` sh
git submodule init
git submodule update
```

* Create the symbolic links

``` sh
cd ..
for f in ".vim" ".vimrc" ".zshrc" ".gdbinit" ".lldbinit" ".oh-my-zsh"; do
    rm -Rf $f;
    ln -s .dotfiles/$f;
done
```
