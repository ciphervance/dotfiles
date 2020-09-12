#!/bin/bash

###########################################
# Setup Docker in Alpine with this Script #
###########################################

# Adds the community repo
sh -c 'echo "http://dl-cdn.alpinelinux.org/alpine/latest-stable/community/" >> /etc/apk/repositories'

# Updates apk to include the new repo we just add
echo "Time to Update"
apk -qq update

# Just as it says, it installs Docker to the Machine
echo "Currently installing Docker"
apk add -qq docker

# This section adds Docker dameon to boot
echo "Enabling Docker at Boot"
rc-update add docker boot

# This starts the Docker daemon
echo "Starting Docker"
service docker start