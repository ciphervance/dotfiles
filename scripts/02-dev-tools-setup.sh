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

OS="$(uname | tr '[:upper:]' '[:lower:]')"
ARCH_RAW="$(uname -m)"
case "${ARCH_RAW}" in
	x86_64) ARCH=amd64 ;;
	aarch64|arm64) ARCH=arm64 ;;
	*) echo "Unsupported arch: ${ARCH_RAW}" >&2; exit 1 ;;
esac

_add_to_rc() {
  local rcfile="$1" snippet="$2"
  grep -qxF "${snippet}" "${rcfile}" 2>/dev/null || {
    echo "# added by 02-dev-tools-setup.sh" >> "${rcfile}"
    echo "${snippet}" >> "${rcfile}"
    echo "  → updated ${rcfile}"
  }
}

if ! command -v go &>/dev/null; then
  echo "➤ Fetching latest Go version..."
  LATEST_GO_FULL="$(curl -fsSL https://go.dev/VERSION?m=text)"  
  # e.g. "go1.21.4"
  LATEST_GO="${LATEST_GO_FULL#go}"                    
  TAR="go${LATEST_GO}.${OS}-${ARCH}.tar.gz"          
  URL="https://go.dev/dl/${TAR}"

  echo "   latest is ${LATEST_GO_FULL}, downloading ${TAR}..."
  TMPDIR="$(mktemp -d)"
  curl -fsSL "${URL}" -o "${TMPDIR}/${TAR}"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "${TMPDIR}/${TAR}"
  rm -rf "${TMPDIR}"
  echo "Installed Go ${LATEST_GO_FULL} to /usr/local/go"

  # ensure PATH in your RCs
  SNIPPET='export PATH=$PATH:/usr/local/go/bin'
  for rc in "${HOME}/.bashrc" "${HOME}/.zshrc"; do
    [ -f "${rc}" ] && _add_to_rc "${rc}" "${SNIPPET}"
  done
else
  INSTALLED_FULL="$(go version | awk '{print $3}')" # e.g. "go1.21.4"
  LATEST_GO_FULL="$(curl -fsSL https://go.dev/VERSION?m=text)"
  if [ "${INSTALLED_FULL}" = "${LATEST_GO_FULL}" ]; then
    echo "Go ${INSTALLED_FULL} already up-to-date"
  else
    echo "Go ${INSTALLED_FULL} installed but ${LATEST_GO_FULL} is available."
    echo "    rerun this script to upgrade or uninstall manually."
  fi
fi

echo

if ! command -v oh-my-posh &>/dev/null; then
  echo "➤ Installing Oh-My-Posh latest release..."
  # GitHub /releases/latest/download will 302 redirect to actual asset
  BIN_URL="https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-${OS}-${ARCH}"
  THEME_URL="https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/jandedobbeleer.omp.json"

  TMPBIN="$(mktemp)"
  curl -fsSL -L "${BIN_URL}" -o "${TMPBIN}"
  sudo install -m755 "${TMPBIN}" /usr/local/bin/oh-my-posh
  rm -f "${TMPBIN}"
  echo "Installed oh-my-posh to /usr/local/bin/oh-my-posh"

  mkdir -p "${HOME}/.poshthemes"
  curl -fsSL -L "${THEME_URL}" -o "${HOME}/.poshthemes/jandedobbeleer.omp.json"
  echo "Downloaded default theme to ~/.poshthemes/"

else
  echo "✔ Oh-My-Posh already installed: $(oh-my-posh --version | head -n1)"
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

