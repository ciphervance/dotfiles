#############################
# Set up Docker on openSUSE #
#############################


# Utilizes Zypper to install Docker and Docker Compose

echo "Installing Docker and Docker Compose!"
zypper install docker docker-compose

# Enables Docker to start on system boot
echo "Enabling Docker at boot!"
sudo systemctl enable docker