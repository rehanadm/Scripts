#!/bin/bash
###Install Docker Engine on RHEL###
# Uninstall old versions
sudo dnf remove docker; docker-client; docker-client-latest; docker-common; docker-latest; docker-latest-logrotate; docker-logrotate; docker-engine; podman; runc
#Set up the repository
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
# Simulate pressing Enter after the repository is added
echo
# To install the latest version, run
sudo dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# Start Docker Engine.
sudo systemctl enable --now docker
