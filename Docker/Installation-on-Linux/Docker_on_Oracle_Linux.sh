#!/bin/bash
# Update Your System
yum update -y
# Install Required Packages
yum install -y yum-utils device-mapper-persistent-data lvm2
# Add Docker Repository
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
# Simulate pressing Enter after the repository is added
echo
# Install Docker
yum install -y docker-ce docker-ce-cli containerd.io
# Start Docker Service
systemctl start docker
# Enable Docker to Start on Boot
systemctl enable docker
# Verify Docker Installation
docker --version
# Run Docker as standard user
# usermod -aG docker $USER
# newgrp docker
# Firewall Configuration
firewall-cmd --zone=public --add-port=2375/tcp --permanent
firewall-cmd --reload

