#!/bin/bash

cur_dir="$(pwd)"

touch ~/.bash_aliases
touch ~/.gitconfig

rm ~/.bash_aliases
rm ~/.bashrc
rm ~/.vimrc
rm ~/.gvimrc
rm -r ~/.vim
rm ~/.tmux.conf

ln -s $cur_dir/git/gitconfig ~/.gitconfig
ln -s $cur_dir/bash/bash_aliases ~/.bash_aliases
ln -s $cur_dir/bash/bashrc ~/.bashrc
ln -s $cur_dir/vim/vimrc ~/.vimrc
ln -s $cur_dir/vim/gvimrc ~/.gvimrc
ln -s $cur_dir/vim ~/.vim
ln -s $cur_dir/tmux.conf ~/.tmux.conf

# git stuff
git config --global color.ui true
