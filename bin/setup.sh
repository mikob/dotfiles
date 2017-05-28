#!/bin/bash
# run from dotfiles, not bin
UBUNTU_EQUIV="xenial"

# installs

# neovim
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update
sudo apt-get install neovim

# general tools
sudo apt install -y git vim zsh trash-cli xclip htop 
chsh -s zsh

# shell tools
git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
git clone https://github.com/jimeh/tmuxifier.git ~/.tmuxifier

# tmux dependencies
sudo apt install libevent-dev build-essential g++ libncurses5-dev -y

# docker
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu $UBUNTU_EQUIV stable"
sudo apt-get update
sudo apt install docker-ce

cur_dir="$(pwd)"
mkdir ~/.config/nvim
 
for x in gitconfig vimrc gvimrc vim tmux.conf zshrc config/nvim/init.vim; do
    echo $x;
    touch ~/.$x;
    rm ~/.$x;
done
     
ln -s $cur_dir/git/gitconfig ~/.gitconfig
ln -s $cur_dir/vim/vimrc ~/.vimrc
ln -s $cur_dir/zsh/custom/themes/prompt_miko_setup ~/.zprezto/modules/prompt/functions
ln -s $cur_dir/vim/gvimrc ~/.gvimrc
ln -s $cur_dir/vim ~/.vim
ln -s $cur_dir/zsh/zshrc ~/.zshrc
ln -s $cur_dir/tmux.conf ~/.tmux.conf
ln -s $cur_dir/vim/init.vim ~/.config/nvim/

