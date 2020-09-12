#!/bin/bash

echo "Installing Homebrew"
# Install Homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "Install Cask"
# Install Cask
brew install caskroom/cask/brew-cask

echo "Utilizing Cask to install Docker"
# Install docker toolbox
brew cask install docker-toolbox