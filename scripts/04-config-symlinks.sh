#!/bin/bash

# 04-config-symlinks.sh
# Copies Starship config and symlinks dotfiles.
# Relies on SCRIPT_ROOT_DIR being set by the caller.

echo "--- Starting Configuration and Symlinking ---"

if [ -z "$SCRIPT_ROOT_DIR" ]; then
    echo "ERROR: SCRIPT_ROOT_DIR must be set in the environment."
    exit 1
fi

# Starship Config File
STARSHIP_CONFIG_SOURCE="${SCRIPT_ROOT_DIR}/terminal/starship.toml"
STARSHIP_CONFIG_DEST_DIR="$HOME/.config"
STARSHIP_CONFIG_DEST_FILE="${STARSHIP_CONFIG_DEST_DIR}/starship.toml"

echo "Setting up Starship configuration..."
if [ -f "$STARSHIP_CONFIG_SOURCE" ]; then
    mkdir -p "$STARSHIP_CONFIG_DEST_DIR"
    cp "$STARSHIP_CONFIG_SOURCE" "$STARSHIP_CONFIG_DEST_FILE"
    echo "Copied starship.toml to $STARSHIP_CONFIG_DEST_FILE"
else
    echo "WARNING: Starship config source not found: $STARSHIP_CONFIG_SOURCE. Skipping copy."
fi

# Symlink files (keeping the original simple approach)
echo "Symlinking dotfiles..."
FILES=('vimrc' 'vim' 'bashrc' 'zsh' 'agignore' 'gitconfig' 'gitignore' 'commit-conventions.txt' 'aliases.zsh')

for file in "${FILES[@]}"; do
    echo ""
    echo "Symlinking $file to $HOME"
    
    # Check if source file exists first
    if [ -e "${SCRIPT_ROOT_DIR}/${file}" ]; then
        ln -sf "${SCRIPT_ROOT_DIR}/${file}" "$HOME/.$file"
        if [ $? -eq 0 ]; then
            echo "${SCRIPT_ROOT_DIR}/${file} ~> $HOME/.$file"
        else
            echo "Install failed to symlink $file."
            exit 1
        fi
    else
        echo "WARNING: Source file not found: ${SCRIPT_ROOT_DIR}/${file}. Skipping."
    fi
done

echo "--- Configuration and Symlinking Finished ---"

