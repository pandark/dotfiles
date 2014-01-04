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

* Create the symbolic links

```
cd ..
rm -f .vim && rm -f .vimrc && rm -f .oh-my-zsh && rm -f .zshrc
ln -s .vim && ln -s .vimrc && ln -s .oh-my-zsh && ln -s .zshrc
```

