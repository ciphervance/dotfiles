#!/bin/bash

###################################################
# Setup Docker on Debian based installs with this #
###################################################

# Updates apt
echo "Updating Operating System"
apt update -y -qq

# Installs some pre-reqs
echo "Installing needed components for Docker"
apt install -y -qq  apt-transport-https ca-certificates curl software-properties-common

# Adds GPG key for the Docker repo
echo "Adding GPGP Key for Docker"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

#Add the Docker repository to APT source
echo "Adding Docker repositories"
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

# Updates apt once more
echo "Updating After adding the Dependices"
apt update -y -qq

# Installs Docker
echo "Installing Docker"
apt install -y -qq docker-ce

# Makes sure that docker is started and made to run at boot
echo "Enable Docker at boot and starting Docker"
systemctl enable docker
systemctl start docker
