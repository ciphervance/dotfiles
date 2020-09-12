#!/bin/bash

#####################################################
# Powershell Installation Script. macOS and Linux   #
#####################################################
 
echo "Installing Homebrew"
# Install Homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "Install Cask"
# Install Cask
brew install caskroom/cask/brew-cask

echo "Using Cask to install Powershell"
# Install Powershell Using Cask
brew cask install powershell

read -p "The installation has completed. Use pwsh to user PowerShell"