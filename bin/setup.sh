#!/bin/bash
# run from dotfiles, not bin

cur_dir="$(pwd)"

touch ~/.gitconfig
touch ~/.bash_aliases
touch ~/.bashrc
touch ~/.vimrc
touch ~/.gvimrc
touch ~/.vim
touch ~/.tmux.conf
touch ~/.zshrc

rm ~/.gitconfig
rm ~/.bash_aliases
rm ~/.bashrc
rm ~/.vimrc
rm ~/.gvimrc
rm -r ~/.vim
rm ~/.tmux.conf
rm ~/.zshrc
rm -r ~/.oh-my-zsh/custom

ln -s $cur_dir/git/gitconfig ~/.gitconfig
ln -s $cur_dir/bash/bash_aliases ~/.bash_aliases
ln -s $cur_dir/bash/bashrc ~/.bashrc
ln -s $cur_dir/vim/vimrc ~/.vimrc
ln -s $cur_dir/vim/gvimrc ~/.gvimrc
ln -s $cur_dir/vim ~/.vim
ln -s $cur_dir/zsh/custom/themes ~/.oh-my-zsh/custom/themes
ln -s $cur_dir/zsh/zshrc ~/.zshrc
ln -s $cur_dir/tmux.conf ~/.tmux.conf

# git stuff
git config --global color.ui true

