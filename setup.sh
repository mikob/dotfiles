#!/bin/bash

# Map caps-lock to escape key
cur_dir="$(pwd)"
xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'

rm ~/.bash_aliases
rm ~/.bashrc
rm ~/.vimrc
rm ~/.gvimrc
rm -r ~/.vim
rm ~/.tmux.conf

ln -s $cur_dir/bash/bash_aliases ~/.bash_aliases
ln -s $cur_dir/bash/bashrc ~/.bashrc
ln -s $cur_dir/vim/vimrc ~/.vimrc
ln -s $cur_dir/vim/gvimrc ~/.gvimrc
ln -s $cur_dir/vim ~/.vim
ln -s $cur_dir/tmux.conf ~/.tmux.conf

# git stuff
git config --global color.ui true

source ~/.bashrc
