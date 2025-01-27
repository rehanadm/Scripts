#!/bin/bash
# update system packages
apt-get update
apt-get upgrade
#  Install Required Packages
apt install apt-transport-https ca-certificates curl software-properties-common
# Add Docker’s Official GPG Key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# Add Docker’s Official Repository
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
# Update Your Package List Again
apt update
# Install Docker
apt install docker-ce
# start Docker Installation
systemctl start docker
# Docker starts automatically on boot
systemctl enable docker

## Run Docker as standard user
# usermod -aG docker $USER

#check Docker version
docker --version


