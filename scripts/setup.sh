#!/bin/bash
# run from dotfiles/, not bin/
# Things that must be done afterwards that are not automated are documented in the README.md
set -e

cur_dir="$(pwd)"
echo "What would you like the hostname to be?"
read hostname

platform=`python3 -c '
import platform
system = platform.system()
if system == "Linux":
    flavor, version, codename = platform.dist()
    if flavor.lower() == "ubuntu":
        print("ubuntu")
    elif flavor.lower() == "fedora":
        print("fedora")
elif system == "Darwin":
    print("mac")
'`
if echo $platform | grep -iq ubuntu; then
    # TODO: set the hostname
    sudo hostnamectl set-hostname $hostname

    # ubuntu, mint
    UBUNTU_EQUIV="bionic"

    # installs

    # general tools
    # xclip and xsel are for neovim clipboard
    sudo apt-get update && sudo apt install -y python3-pip git zsh trash-cli xclip htop tree jq silversearcher-ag mosh nethogs xsel xclip fd-find

    # desktop tools (not needed on server)
    sudo apt-get install earlyoom

    # tmux dependencies
    # sudo apt install libevent-dev build-essential g++ libncurses5-dev -y

    # global keyboard shortcuts
    sudo apt install sxhkd

    # docker
    sudo apt-get install -y \
	apt-transport-https \
	ca-certificates \
	curl \
	software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu $UBUNTU_EQUIV stable"
    sudo apt-get update
    sudo apt install -y docker-ce

    # shell
    sudo chsh -s /bin/zsh $(whoami)
    sudo chsh -s /bin/zsh

elif echo $platform | grep -iq fedora; then

    # fedora
    curl -o /etc/yum.repos.d/dperson-neovim-epel-7.repo https://copr.fedorainfracloud.org/coprs/dperson/neovim/repo/epel-7/dperson-neovim-epel-7.repo && yum -y install neovim

    # general tools
    sudo dnf -y install zsh xclip htop tree tmux trash-cli parcellite the_silver_searcher jq nethogs

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
elif echo $platform | grep -iq mac; then
    # install homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew install zsh
    brew install wget
    brew install htop
    brew install tmux
    brew install git-delta
    brew install the_silver_searcher
    sudo chsh -s /bin/zsh
else
    echo "Could not recognize OS"
    exit 1
fi

# entr for watching for executing commands when files change
wget https://github.com/eradman/entr/archive/refs/tags/5.2.tar.gz
tar -xf 5.2.tar.gz
pushd entr-*
./configure && make && sudo make install
popd

# stuff for both distros
if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# nvim
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
sudo mv nvim.appimage /opt/nvim.appimage && sudo chmod u+x /opt/nvim.appimage
sudo ln -fs /opt/nvim.appimage /usr/local/bin/nvim
sudo ln -fs /opt/nvim.appimage /usr/local/bin/vim

# nvim plugin manager
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# vifm (cmd line file manager)
wget https://github.com/vifm/vifm/releases/download/v0.9/vifm-0.9.tar.bz2 && tar -xf vifm-0.9* && cd vifm-0.9 && ./configure && make && sudo make install

# shell tools
if [ ! -d "${HOME}/.zgen" ]; then
    git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
fi

# diff-so-fancy
wget https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy && chmod +x diff-so-fancy && sudo mv diff-so-fancy /usr/local/bin

# python tools
pip3 install --user httpie neovim-remote

mkdir -p ~/.config/nvim
mkdir -p ~/.config/rofi

# remove pre-existing
for x in gitconfig vimrc gvimrc vim tmux.conf zshrc config/nvim/init.vim; do
    echo $x;
    touch ~/.$x;
    rm ~/.$x;
done

ln -s $cur_dir/git/gitconfig ~/.gitconfig
ln -s $cur_dir/git/gitignore_global ~/.gitignore_global
ln -s $cur_dir/vim/vimrc ~/.vimrc
ln -s $cur_dir/vim/gvimrc ~/.gvimrc
ln -s $cur_dir/vim ~/.vim
ln -s $cur_dir/zsh/zshrc ~/.zshrc
ln -s $cur_dir/tmux.conf ~/.tmux.conf
ln -s $cur_dir/vim/init.vim ~/.config/nvim/
ln -s $cur_dir/config.rasi ~/.config/rofi/

# scripts
ln -s $cur_dir/scripts/nemo/ ~/.local/share/nemo/scripts/

# if not mac
if echo $platform | grep -viq mac; then
    sudo ln -s $cur_dir/earlyoom /etc/default/
fi

# finish tmux plugins
# todo run tmux server and detach it?
tmux source ~/.tmux.conf

# post docker
sudo usermod -aG docker $USER
sudo groupadd docker

# zgen initialization
zgen-init
~/.zgen/junegunn/fzf-master/install --no-update-rc --no-fish --no-bash
ln -s $cur_dir/zsh/custom/themes/prompt_miko_setup ~/.zgen/sorin-ionescu/prezto-master/modules/prompt/functions

echo "Done setting up!"
