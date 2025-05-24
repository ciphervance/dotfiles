#!/bin/bash

# 02-dev-tools-setup.sh
# Installs various development tools and utilities.

echo "--- Starting Development Tools Setup ---"

# Setup NVIM
echo "Setting up Neovim..."
if command -v nvim &>/dev/null && [[ "$(nvim --version | head -n 1)" == "NVIM"* ]]; then
    echo "Neovim appears to be installed. Checking version/source or skipping."
    # Add logic here if you want to ensure it's your /opt/nvim version
else
    echo "Downloading and installing Neovim to /opt/nvim..."
    TEMP_NVIM_DIR=$(mktemp -d)
    curl -Lo "${TEMP_NVIM_DIR}/nvim-linux64.tar.gz" https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf "${TEMP_NVIM_DIR}/nvim-linux64.tar.gz"
    rm -rf "${TEMP_NVIM_DIR}" # Clean up
    echo "Neovim installed to /opt/nvim. Add /opt/nvim-linux64/bin to your PATH."
    # Consider adding to PATH via a profile script if not handled by zshrc/bashrc symlinks
    if [ ! -f /usr/local/bin/nvim ] && [ -d /opt/nvim-linux64/bin ]; then
        sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
        echo "Symlinked nvim to /usr/local/bin/nvim"
    fi
fi

# pynvim
echo "Installing pynvim for Neovim Python support..."
if /usr/bin/python3 -m pip show pynvim &>/dev/null; then
    echo "pynvim already installed."
else
    /usr/bin/python3 -m pip install --user pynvim
    echo "pynvim installed for the current user."
fi

# Install Nerd Font (Hack)
echo "Installing Hack Nerd Font..."
NERDFONT_VERSION="v3.2.1" # Or use "latest" if API allows, else check manually
NERDFONT_NAME="Hack"
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

# Check if a Hack Nerd Font is already installed to avoid re-downloading
if fc-list | grep -qi "Hack Nerd Font"; then
    echo "Hack Nerd Font already installed."
else
    echo "Downloading and installing Hack Nerd Font..."
    TEMP_FONT_DIR=$(mktemp -d)
    wget -qO "${TEMP_FONT_DIR}/${NERDFONT_NAME}.zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/${NERDFONT_VERSION}/${NERDFONT_NAME}.zip"
    if [ $? -eq 0 ]; then
        unzip -q "${TEMP_FONT_DIR}/${NERDFONT_NAME}.zip" -d "${TEMP_FONT_DIR}/${NERDFONT_NAME}NerdFont"
        # Copy only .ttf or .otf files
        find "${TEMP_FONT_DIR}/${NERDFONT_NAME}NerdFont" \( -name "*.ttf" -o -name "*.otf" \) -exec cp {} "$FONT_DIR/" \;
        echo "Updating font cache..."
        fc-cache -f -v
        echo "Hack Nerd Font installed."
    else
        echo "ERROR: Failed to download Hack Nerd Font."
    fi
    rm -rf "${TEMP_FONT_DIR}" # Clean up
fi


# Installing OhMyZSH
echo "Installing OhMyZSH..."
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "OhMyZSH already installed."
else
    echo "Attempting to install OhMyZSH. It might prompt to change your default shell."
    # CHSH=no RUNZSH=no prevents the script from trying to change shell and exit
    # The --unattended flag attempts a non-interactive install
    if sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; then
        echo "OhMyZSH installation script finished."
        echo "If ZSH is not your default shell, change it manually: chsh -s \$(which zsh)"
        echo "Then, start a new ZSH session."
    else
        echo "ERROR: OhMyZSH installation failed."
    fi
fi

# Install Rust Up
echo "Installing Rust via rustup..."
if command -v rustc &>/dev/null; then
    echo "Rust (rustc) already installed."
else
    # The -y flag automates the installation, --no-modify-path prevents it from altering .profile/.bashrc directly
    # You'll need to source "$HOME/.cargo/env" or add it to your shell's config manually
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
    echo "Rust installed via rustup. Source \"\$HOME/.cargo/env\" or add it to your shell config."
    echo "For the current session, you can run: source \"\$HOME/.cargo/env\""
fi

# Setup Starship
echo "Installing Starship prompt..."
if command -v starship &>/dev/null; then
    echo "Starship already installed."
else
    # The -y flag attempts a non-interactive install
    if curl -sS https://starship.rs/install.sh | sh -s -- -y; then
        echo "Starship installed. Add 'eval \"\$(starship init zsh)\"' (or bash/fish) to your shell config."
    else
        echo "ERROR: Starship installation failed."
    fi
fi

echo "--- Development Tools Setup Finished ---"

