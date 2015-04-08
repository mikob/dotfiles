#!/bin/bash
# run from dotfiles, not bin

cur_dir="$(pwd)"

touch ~/.gitconfig
touch ~/.vimrc
touch ~/.gvimrc
touch ~/.vim
touch ~/.tmux.conf
touch ~/.zshrc
touch ~/.ackrc

rm ~/.gitconfig
rm ~/.vimrc
rm ~/.gvimrc
rm -r ~/.vim
rm ~/.tmux.conf
rm ~/.zshrc
rm -r ~/.oh-my-zsh/custom
rm ~/.ackrc

ln -s $cur_dir/git/gitconfig ~/.gitconfig
ln -s $cur_dir/vim/vimrc ~/.vimrc
ln -s $cur_dir/vim/gvimrc ~/.gvimrc
ln -s $cur_dir/vim ~/.vim
ln -s $cur_dir/zsh/custom ~/.oh-my-zsh/custom
ln -s $cur_dir/zsh/zshrc ~/.zshrc
ln -s $cur_dir/tmux.conf ~/.tmux.conf
ln -s $cur_dir/ackrc ~/.ackrc

# git stuff
git config --global color.ui true

