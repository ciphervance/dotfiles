#!/usr/bin/env bash
# A script for setting up post install Debian & Ubuntu Distros
# Relies on Flatpak to be installed
# Created by Blake Ridgway
# 2021 July 9th

PACKAGE_LIST=(
  neovim
  zsh
  tilix
  openjdk-11-jre
  virt-manager
  discord
  neofetch
  htop
  steam
  vlc
  python3
  python3-pip
  system76-keyboard-configurator
  solaar
)

FLATPAK_LIST=(
  com.mattermost.Destkop
  com.mojang.Minecraft
  com.obsproject.Studio
  com.runelite.RuneLite
  net.veloren.Airshipper
  org.signal.Signal
  org.telegram.desktop
)

# Nerd Font install
wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete.ttf
mkdir -p ~/.local/share/fonts 
cp Hack\ Regular\ Nerd\ Font\ Complete.ttf ~/.local/share/fonts/
fc-cache -f -v

# Grabs and downloads Go for Google
wget https://golang.org/dl/go1.16.4.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.16.4.linux-amd64.tar.gz

# Install Rust
curl https://sh.rustup.rs -sSf | sh

# SSH Key Gen
ssh-keygen -t ed25519 -C "blake@blakeridgway.dev"

# Oh My ZSH is installer
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# POWERLEVEL10K
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Copy p10k Config file
cp .p10k.zsh ~/

# Fancy ls script taken from github.com/brandonroehl/dotfiles
files=( 'vimrc' 'vim' 'zshrc' 'zsh' 'agignore' 'gitconfig' 'gitignore' 'gitmessage' 'eslintrc' )
for file in $files
do
  echo ""
  echo "Simlinking $file to $HOME"
  ln -sf "$PWD/$file" "$HOME/.$file"
  if [ $? -eq 0 ]
  then
    echo "$PWD/$file ~> $HOME/.$file"
  else
    echo 'Install failed to symlink.'
    exit 1
  fi
done

# iterate through package and installs them
for package_name in ${PACKAGE_LIST[@]}; do
  if ! sudo apt list --installed | grep -q "^\<$package_name\>"; then
    echo "Installing $package_name..."
    sleep .5
    sudo apt install "$package_name" -y
    echo "$package_name has been installed"
  else
    echo "$package_name already installed"
  fi
done

for flatpak_name in ${FLATPAK_LIST[@]}; do
	if ! flatpak list | grep -q $flatpak_name; then
		flatpak install "$flatpak_name" -y
	else
		echo "$package_name already installed"
	fi
done

mkdir -p ~/.config/nvim/
echo $'set runtimepath^=~/.vim runtimepath+=~/.vim/after\nlet &packpath=&runtimepath\nsource ~/.vimrc' > ~/.config/nvim/init.vim

sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
flatpak update
