#!/bin/bash

# 00-system-prep.sh
# Updates system and sets up Flathub.
# Relies on DISTRO and PACKAGE_MANAGER being set by the caller.

echo "--- Starting System Preparation ---"

if [ -z "$DISTRO" ] || [ -z "$PACKAGE_MANAGER" ]; then
    echo "ERROR: DISTRO and PACKAGE_MANAGER must be set in the environment."
    exit 1
fi

# Update system before installing packages
echo "Updating system packages..."
if [ "$PACKAGE_MANAGER" == "dnf" ]; then
    sudo dnf update -y && sudo dnf upgrade -y
elif [ "$PACKAGE_MANAGER" == "apt" ]; then
    sudo apt update && sudo apt upgrade -y
else
    echo "WARNING: Unknown package manager '$PACKAGE_MANAGER'. Skipping system update."
fi

# Setup Flatpak
echo "Setting up Flathub repository..."
if command -v flatpak &> /dev/null; then
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
else
    echo "WARNING: flatpak command not found. Skipping Flathub setup."
    echo "Ensure Flatpak is installed via 01-package-install.sh or manually."
fi

echo "--- System Preparation Finished ---"

