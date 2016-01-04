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
for f in ".vim" ".vimrc" ".zshrc" ".gdbinit" ".lldbinit" ".exclude" ".oh-my-zsh"; do
    rm -Rf $f;
    ln -s .dotfiles/$f;
done
```

## Install @ 42

* Mount the remote (goinfre) home

``` sh
if [ ! -d ~/.remote_home ]; then
    mkdir ~/.remote_home
fi
if [ -z $(mount | grep ".remote_home") ]; then
    mount -t nfs zfs-student-1:/tank/sgoinfre/goinfre/Perso/Students/$(whoami) ~/.remote_home
fi
```

* Clone the repo

``` sh
git clone https://github.com/pandark/dotfiles.git ~/.remote_home/.dotfiles
cd ~/.remote_home/.dotfiles
```

* Clone submodules

``` sh
git submodule init
git submodule update
```

* Create a minimal .zshrc

``` sh
echo -e "if [ ! -d ~/.remote_home ]; then" > ~/.zshrc
echo -e "    mkdir ~/.remote_home" >> ~/.zshrc
echo -e "fi" >> ~/.zshrc
echo -e "if [ -z \$(mount | grep ".remote_home") ]; then" >> ~/.zshrc
echo -e "    mount -t nfs zfs-student-1:/tank/sgoinfre/goinfre/Perso/Students/$(whoami) ~/.remote_home" >> ~/.zshrc
echo -e "fi" >> ~/.zshrc
echo -e "if [ -f ~/.remote_home/.dotfiles/.zshrc ]; then" >> ~/.zshrc
echo -e "    source ~/.remote_home/.dotfiles/.zshrc" >> ~/.zshrc
echo -e "fi" >> ~/.zshrc
```

* Create the symbolic links

``` sh
cd ~/
for f in ".vim" ".vimrc" ".gdbinit" ".lldbinit" ".exclude" ".oh-my-zsh"; do
    rm -Rf $f;
    ln -s .dotfiles/$f;
done
```
