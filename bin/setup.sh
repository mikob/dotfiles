#!/bin/bash
# run from dotfiles, not bin

cur_dir="$(pwd)"

touch ~/.gitconfig
touch ~/.bash_aliases
touch ~/.bashrc
touch ~/.vimrc
touch ~/.gvimrc
touch -r ~/.vim
touch ~/.tmux.conf
touch ~/.zshrc
touch ~/.oh-my-zsh

rm ~/.gitconfig
rm ~/.bash_aliases
rm ~/.bashrc
rm ~/.vimrc
rm ~/.gvimrc
rm -r ~/.vim
rm -r ~/.oh-my-zsh
rm ~/.tmux.conf
rm ~/.zshrc

ln -s $cur_dir/git/gitconfig ~/.gitconfig
ln -s $cur_dir/bash/bash_aliases ~/.bash_aliases
ln -s $cur_dir/bash/bashrc ~/.bashrc
ln -s $cur_dir/vim/vimrc ~/.vimrc
ln -s $cur_dir/vim/gvimrc ~/.gvimrc
ln -s $cur_dir/vim ~/.vim
ln -s $cur_dir/zsh/oh-my-zsh ~/.oh-my-zsh
ln -s $cur_dir/zsh/zshrc ~/.zshrc
ln -s $cur_dir/tmux.conf ~/.tmux.conf

# git stuff
git config --global color.ui true

