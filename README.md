===========
42 dotfiles
===========

## Install

* Clone the repo

```
git clone https://github.com/pandark/dotfiles.git
```

* Checkout the 42 branch

```
cd dotfiles
git checkout 42
```

* Clone submodules

```
git submodule init
git submodule update
```

* Create the symbolic links

```
cd ..
rm -f .vim && rm -f .vimrc && rm -f .oh-my-zsh && rm -f .zshrc
ln -s dotfiles/.vim && ln -s dotfiles/.vimrc && ln -s dotfiles/.oh-my-zsh \
&& ln -s dotfiles/.zshrc
```

