#!/bin/bash

##INSTALLING NAGIOS ON UBUNTU 22.04
# Install dependencies
sudo apt update; sudo apt install wget unzip curl openssl build-essential libgd-dev libssl-dev libapache2-mod-php php-gd php apache2

# Change directory to nagios and create nagios folder
cd /opt; sudo mkdir nagios; cd nagios

# Download latest Nagios package[
wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.4.11.tar.gz

# Extract downloaded tar.gz file
sudo tar -zxvf nagios-4.4.11.tar.gz

# Change directory to nagios and run ./configure
cd nagios-4.4.11; sudo ./configure

# Run make all
sudo make all

# Create required Nagios user and group
sudo make install-groups-users; groupadd -r nagios; useradd -g nagios nagios

# Add apache user to the nagios group
sudo usermod -a -G nagios www-data

# Install Nagios
sudo make install

# make install-commandmode ; This installs and configures permissions on the directory for holding the external command file.
sudo make install-commandmode

# Install the configuration files
sudo make install-config

# Install apache config files
sudo make install-webconf

# Enable the rewrite and cgi modules of apache2.
sudo a2enmod rewrite; sudo a2enmod cgi

# Configure UFW for apache
sudo ufw allow apache; sudo ufw enable; sudo ufw reload

# Restart apache2
sudo systemctl restart apache2

# Create a nagios user for logging from WEB.My user is nagiosadmin
printf "yourpassword\n" | sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagi

##Install Nagios Plugins <current version is 2.4.4>
cd /opt/nagios; wget https://nagios-plugins.org/download/nagios-plugins-2.4.4.tar.gz

#  Extract tar.gz file
sudo tar -zxvf nagios-plugins-2.4.4.tar.gz

# Change to extracted plugins directory and run configure script
cd nagios-plugins-2.4.4; sudo ./configure --with-nagios-user=nagios --with-nagios-group=nagios

# Install Nagios plugins
sudo make install

# Run Nagios as a daemon
sudo /usr/local/nagios/bin/nagios -d /usr/local/nagios/etc/nagios.cfg


# Login to Nagios web Page with below URL:
# http://server_ip/nagios
# username = nagiosadmin
# password = yourpassword
