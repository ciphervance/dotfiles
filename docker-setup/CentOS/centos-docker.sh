#########################################
# Set up Docker on CentOS based Distros #
#########################################

# Removes older installs of Docker
    echo 'Removing older Docker versions'
    sudo yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
            
# Set ups the needed repos and deps
    sudo yum install -y yum-utils device-mapper-persistent-data lvm2
    sudo yum-config-manager --add-repo  https://download.docker.com/linux/centos/docker-ce.repo 
            
# Installs DockerCE
    sudo yum install docker docker-ce docker-ce-cli containerd.io

# Starts Docker
    sudo systemctl start docker

# Tests to make sure Docker is running correctly
    sudo docker run hello-world