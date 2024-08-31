#!/bin/bash

# A script for setting up post install
# Relies on Flatpak to be installed
# Created by Blake Ridgway

# Function to detect the Linux distribution
detect_linux_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    elif [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        echo "$DISTRIBUTOR_ID"
    elif [ -f /etc/debian_version ]; then
        echo "debian"
    elif [ -f /etc/redhat-release ]; then
        echo "redhat"
    else
        echo "unknown"
    fi
}

# Detect the Linux distribution
DISTRO=$(detect_linux_distro)

# Determine the appropriate package manager
case "$DISTRO" in
    fedora|rhel|centos)
        PACKAGE_MANAGER="dnf"
        ;;
    debian|ubuntu|pop)
        PACKAGE_MANAGER="apt"
        ;;
    *)
        echo "Unsupported distribution: $DISTRO"
        exit 1
        ;;
esac

# Update system before installing packages
if [ "$PACKAGE_MANAGER" == "dnf" ]; then
    sudo dnf update && sudo dnf upgrade
elif [ "$PACKAGE_MANAGER" == "apt" ]; then
    sudo apt update && sudo apt upgrade -y
fi

# Setup Flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

PACKAGE_LIST=(
    btop
    curl
    git
    gh
    fd-find
    flatpak
    libfontconfig-dev
    libssl-dev
    neofetch
    python3
    python3-pip
    ripgrep
    virt-manager
    zsh
)

FLATPAK_LIST=(
    com.bitwarden.desktop
    com.github.tchx84.Flatseal
    com.valvesoftware.Steam
    net.davidotek.pupgui2
    net.veloren.airshipper
    org.videolan.VLC
)

echo #######################
echo # Installing Packages #
echo #######################

for package_name in ${PACKAGE_LIST[@]}; do
    if [ "$PACKAGE_MANAGER" == "dnf" ]; then
        if ! dnf list --installed | grep -q "^\<$package_name\>"; then
            echo "Installing $package_name..."
            sleep .5
            sudo dnf install "$package_name" -y
            echo "$package_name has been installed"
        else
            echo "$package_name already installed"
        fi
    elif [ "$PACKAGE_MANAGER" == "apt" ]; then
        if ! dpkg -l | grep -q "^\<ii\> $package_name"; then
            echo "Installing $package_name..."
            sleep .5
            sudo apt install "$package_name" -y
            echo "$package_name has been installed"
        else
            echo "$package_name already installed"
        fi
    fi
done

for flatpak_name in ${FLATPAK_LIST[@]}; do
    if ! flatpak list | grep -q $flatpak_name; then
        flatpak install "$flatpak_name" -y
    else
        echo "$flatpak_name already installed"
    fi
done

echo ##########
echo # pynvim #
echo ##########

/usr/bin/python3 -m pip install pynvim

echo #####################
echo # Install Nerd Font #
echo #####################

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.zip && unzip Hack.zip -d Hack
mkdir -p ~/.local/share/fonts && cp Hack/HackNerdFont-Regular.ttf ~/.local/share/fonts
fc-cache -f -v
rm -rf Hack*


echo ######################
echo # Installing OhMyZSH #
echo ######################

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


echo ###################
echo # Install Rust Up #
echo ###################

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo ##################
echo # Setup Starship #
echo ##################

curl -sS https://starship.rs/install.sh | sh

echo ###############
echo # Config File #
echo ###############

cp terminal/starship.toml ~/.config/starship.toml

echo ###################
echo # Setting up nvim #
echo ###################

cp -r terminal/nushell/ ~/.config/


# Symlink files

FILES=('vimrc' 'vim' 'zshrc' 'zsh' 'agignore' 'gitconfig' 'gitignore' 'gitmessage' 'aliases')
for file in ${FILES[@]}; do
	echo ""
	echo "Simlinking $file to $HOME"
	ln -sf "$PWD/$file" "$HOME/.$file"
	if [ $? -eq 0 ]; then
		echo "$PWD/$file ~> $HOME/.$file"
	else
		echo 'Install failed to symlink.'
		exit 1
	fi
done
