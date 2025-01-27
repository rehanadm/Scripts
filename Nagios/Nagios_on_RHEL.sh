#!/bin/bash

# Install Nagios Monitoring Tool on RHEL 8
#Requirements:
#RHEL 8 with Minimal Installation
#RHEL 8 with RedHat Subscription Enabled
#RHEL 8 with Static IP Address

# Install Required Dependencies
dnf install -y gcc glibc glibc-common perl httpd php wget gd gd-devel

#start the HTTPD service for now, enable it to automatically start at system boot
systemctl start httpd; systemctl enable httpd

# Downloading, Compiling and Installing Nagios Core
cd /opt; mkdir nagios; cd nagios; wget -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.3.tar.gz; tar xzf nagioscore.tar.gz; cd nagioscore-nagios-4.4.3/

#configure the source package and build it.
./configure; make all

create the Nagios User and Group, and add the Apache user to the Nagios Group
make install-groups-users; usermod -a -G nagios apache

# install the binary files, CGIs, and HTML files
make install; make install-daemoninit

#install and configure the external command file, a sample configuration file and the Apache-Nagios configuration file
make install-commandmode		#installs and configures the external command file
make install-config			#installs the *SAMPLE* configuration files.  
make install-webconf		        #installs the Apache web server configuration files. 

# secure the Nagios Core web console using HTTP basic authentication.
printf "yourpassword\n" | sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin

# Installing Nagio Plugins in RHEL 8 & packages for compiling and building the plugin package.
dnf install -y gcc glibc glibc-common make gettext automake autoconf wget openssl-devel net-snmp net-snmp-utils
cd /opt/nagios; wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz; tar zxf nagios-plugins.tar.gz

# Move into the extracted directory, compile, build and install the Nagios Plugins install the Nagios Plugins
cd nagios-plugins-release-2.2.1; ./tools/setup; ./configure; make; make install

# set up the Nagios Core service and configured it to work with the Apache HTTP server. Now you need to restart the HTTPD service
systemctl restart httpd.service
systemctl start nagios.service
systemctl enable nagios.service

# If you have firewall running, need to open port 80 in the firewall
firewall-cmd --permanent --zone=public --add-port=80/tcp
firewall-cmd --reload

# Accessing Nagios Web Console in RHEL 8
# http://server_ip/nagios
# username = nagiosadmin
# password = yourpassword
