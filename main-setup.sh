#!/bin/bash

# Main setup script
# Calls other scripts to perform post-installation tasks.

# --- Global Variables & Helper Functions ---
# SCRIPT_ROOT_DIR will be the directory where main-setup.sh is located
export SCRIPT_ROOT_DIR
SCRIPT_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
export SCRIPTS_DIR="${SCRIPT_ROOT_DIR}/scripts"

# Function to detect the Linux distribution
detect_linux_distro() {
    if [ -f /etc/os-release ]; then
        # shellcheck disable=SC1091
        . /etc/os-release
        echo "$ID"
    elif [ -f /etc/lsb-release ]; then
        # shellcheck disable=SC1091
        . /etc/lsb-release
        echo "$DISTRIBUTOR_ID"
    elif [ -f /etc/debian_version ]; then
        echo "debian"
    elif [ -f /etc/redhat-release ]; then
        if grep -qi "fedora" /etc/redhat-release; then
            echo "fedora"
        elif grep -qi "centos" /etc/redhat-release; then
            echo "centos"
        elif grep -qi "red hat enterprise linux" /etc/redhat-release; then
            echo "rhel"
        else
            echo "redhat"
        fi
    else
        echo "unknown"
    fi
}

# Detect the Linux distribution and set package manager
export DISTRO
DISTRO=$(detect_linux_distro)

export PACKAGE_MANAGER
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

echo "Detected Distribution: $DISTRO"
echo "Using Package Manager: $PACKAGE_MANAGER"
echo "Script Root Directory: $SCRIPT_ROOT_DIR"
echo "--------------------------------------------------"

# --- Execute Setup Scripts ---

echo "Executing 00-system-prep.sh..."
if ! bash "${SCRIPTS_DIR}/00-system-prep.sh"; then
    echo "ERROR: 00-system-prep.sh failed."
    exit 1
fi
echo "--------------------------------------------------"

echo "Executing 01-package-install.sh..."
if ! bash "${SCRIPTS_DIR}/01-package-install.sh"; then
    echo "ERROR: 01-package-install.sh failed."
    exit 1
fi
echo "--------------------------------------------------"

echo "Executing 02-dev-tools-setup.sh..."
if ! bash "${SCRIPTS_DIR}/02-dev-tools-setup.sh"; then
    echo "ERROR: 02-dev-tools-setup.sh failed."
    exit 1
fi
echo "--------------------------------------------------"

if [ "$DISTRO" == "fedora" ]; then
    echo "Executing 03-fedora-dotnet-setup.sh..."
    if ! bash "${SCRIPTS_DIR}/03-fedora-dotnet-setup.sh"; then
        echo "ERROR: 03-fedora-dotnet-setup.sh failed."
        # Decide if this is a fatal error for the whole script
        # exit 1
    fi
    echo "--------------------------------------------------"
fi

echo "Executing 04-config-symlinks.sh..."
if ! bash "${SCRIPTS_DIR}/04-config-symlinks.sh"; then
    echo "ERROR: 04-config-symlinks.sh failed."
    # exit 1
fi
echo "--------------------------------------------------"

echo ""
echo "#####################################"
echo # Main setup script finished!         #
echo #####################################"
echo "Please review the output for any manual steps or errors."
echo "You may need to restart your terminal or log out/log in for all changes to take effect."

exit 0

