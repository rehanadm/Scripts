#!/bin/bash

##Install Jenkins on Ubuntu 24.04##
# Update the System
sudo apt update -y && sudo apt upgrade -y

# Install Java
sudo apt install openjdk-21-jdk -y

# Add Jenkins GPG key and Repository
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null

# update the repository
sudo apt update -y

# Install jenkins
sudo apt install jenkins -y

# Start and enable jenkins service
sudo systemctl start jenkins && sudo systemctl enable jenkins

#Install Apache And Create Apache Configuration
sudo apt install apache2 -y

# start and enable the apache2 service
sudo systemctl enable apache2 && sudo systemctl start apache2

# Create an Apache configuration file 
touch jenkins.conf

cat <<EOF >> ./jenkins.conf
<VirtualHost *:80>
    ServerName        yourdomain.com
    ProxyRequests     Off
    ProxyPreserveHost On
    AllowEncodedSlashes NoDecode

    # Use the correct location for access control
    <Directory "/">
        Require all granted
    </Directory>

    ProxyPass         /  http://localhost:8080/ nocanon
    ProxyPassReverse  /  http://localhost:8080/
</VirtualHost>
EOF

sudo chown root:root ./jenkins.conf
sudo mv ./jenkins.conf /etc/apache2/sites-available/jenkins.conf

# enable the Jenkins configuration and some Apache modules:
sudo a2ensite jenkins; sudo a2enmod headers; sudo a2enmod rewrite; sudo a2enmod proxy; sudo a2enmod proxy_http; sudo systemctl restart apache2

## Access the URL using http://<IPADDRESS>:8080 and copy/paste Administrator Password located on below path:
sudo cat /var/lib/jenkins/secrets/initialAdminPassword 

# On browser over Jenkins GUI <customize jenkins> 
# select Install suggested plugins
# Create First Admin User  
# Instance configuration,Jenkins URL http://<IPADDRESS>:80
# save and start using Jenkins!!!
