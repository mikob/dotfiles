#!/bin/bash
# run from dotfiles/, not bin/
# Things that must be done afterwards that are not automated are documented in the README.md
if python -mplatform | grep -iq ubuntu; then
    # ubuntu, mint
    UBUNTU_EQUIV="zesty"

    # installs

    # neovim
    sudo add-apt-repository ppa:neovim-ppa/unstable
    sudo apt-get update
    sudo apt-get install neovim

    # general tools
    sudo apt install -y git vim zsh trash-cli xclip htop tree jq silversearcher-ag

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

    # shell
    chsh -s zsh
    chsh -s zsh $(whoami)
    sudo chsh -s zsh
elif python -mplatform | grep -iq fedora; then
    exit 1
    # fedora
    curl -o /etc/yum.repos.d/dperson-neovim-epel-7.repo https://copr.fedorainfracloud.org/coprs/dperson/neovim/repo/epel-7/dperson-neovim-epel-7.repo && yum -y install neovim

    # general tools
    sudo dnf -y install zsh xclip htop tree tmux trash-cli parcellite the_silver_searcher jq

    # for vifm
    sudo dnf -y install ncurses-static.x86_64

    # docker
    sudo dnf -y install dnf-plugins-core
    sudo dnf config-manager \
	--add-repo \
	https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf makecache fast
    sudo dnf -y install docker-ce
    sudo systemctl start docker

    sudo lchsh -i $USER /bin/zsh
else
    echo "Could not recognize OS"
    exit 1
fi

# finish tmux plugins
tmux source ~/.tmux.conf

# stuff for both distros
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# nvim plugin manager
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# vifm (cmd line file manager)
wget https://github.com/vifm/vifm/releases/download/v0.9/vifm-0.9.tar.bz2 && cd vifm-0.9 && ./configure && make && sudo make install

# shell tools
git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
~/.zgen/junegunn/fzf-master/install --no-update-rc --no-fish --no-bash

# python tools
pip install --user httpie

cur_dir="$(pwd)"
mkdir ~/.config/nvim

for x in gitconfig vimrc gvimrc vim tmux.conf zshrc config/nvim/init.vim; do
    echo $x;
    touch ~/.$x;
    rm ~/.$x;
done

ln -s $cur_dir/git/gitconfig ~/.gitconfig
ln -s $cur_dir/vim/vimrc ~/.vimrc
ln -s $cur_dir/zsh/custom/themes/prompt_miko_setup ~/.zgen/sorin-ionescu/prezto-master/modules/prompt/functions
ln -s $cur_dir/vim/gvimrc ~/.gvimrc
ln -s $cur_dir/vim ~/.vim
ln -s $cur_dir/zsh/zshrc ~/.zshrc
ln -s $cur_dir/tmux.conf ~/.tmux.conf
ln -s $cur_dir/vim/init.vim ~/.config/nvim/

# xonsh
mkdir ~/.config/xonsh
ln -s $cur_dir/xonsh/config.json ~/.config/xonsh/
ln -s $cur_dir/xonsh/xonshrc ~/.xonshrc

# post docker
sudo usermod -aG docker $USER
sudo groupadd docker
