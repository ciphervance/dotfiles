#########################################
# Ubuntu PowerShell Installation Script #
# Created by Blake Ridgway		#
# libicu52 Package location		#
# https://debian.pkgs.org/8/debian-main-amd64/libicu52_52.1-8+deb8u7_amd64.deb.html
#########################################


# Download the Microsoft repository GPG keys
wget -q https://packages.microsoft.com/config/ubuntu/14.04/packages-microsoft-prod.deb

# Register the Microsoft repository GPG keys
sudo dpkg -i packages-microsoft-prod.deb
            
# Update the list of products
sudo apt update; sudo apt upgrade

# Downloads the libicu52 dependecy
wget -q http://ftp.br.debian.org/debian/pool/main/i/icu/libicu52_52.1-8+deb8u7_amd64.deb

# Installs the libicu52 dependecy 
sudo dpkg -i libicu52_52.1-8+deb8u7_amd64.deb

# Install PowerShell
sudo apt-get install -y powershell

echo "The installation has completed. Use pwsh to user PowerShell"
