#!/bin/bash

# Step 1: Update the system
echo "Updating system packages..."
sudo apt update -y && sudo apt upgrade -y

# Step 2: Install required dependencies
echo "Installing required dependencies..."
sudo apt install -y \
    apache2 \
    mariadb-server \
    libapache2-mod-passenger \
    ruby \
    ruby-dev \
    build-essential \
    libmysqlclient-dev \
    imagemagick \
    libmagickwand-dev \
    git \
    curl \
    unzip

# Step 3: Install the required Ruby gems
echo "Installing required Ruby gems..."
sudo gem install bundler

# Step 4: Create a Redmine user and download Redmine
echo "Creating Redmine user and downloading Redmine..."
sudo useradd -m -s /bin/bash redmine << EOF
Redmine
Redmine User
123-456-7890
Redmine Address
Room 101
321-654-9870
N/A
yes
EOF
user= tail -n 1 /etc/passwd | awk '{ print $1 }'
# Notify the user that the user has been added successfully
echo "User $user has been added successfully."

# Install git
apt install git

# Step 5: Set up the Redmine database
echo "Setting up the database..."
sudo mysql -u root -e "CREATE DATABASE redmine CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
sudo mysql -u root -e "CREATE USER 'redmine'@'localhost' IDENTIFIED BY 'password';"
sudo mysql -u root -e "GRANT ALL PRIVILEGES ON redmine.* TO 'redmine'@'localhost';"
sudo mysql -u root -e "FLUSH PRIVILEGES;"

# Step 6: Configure Redmine
echo "Configuring Redmine..."
sudo mkdir -p /home/redmine/redmine
sudo chown redmine:redmine /home/redmine/redmine
sudo su - redmine -c "git clone https://github.com/redmine/redmine.git /home/redmine/redmine"
cd /home/redmine/redmine/redmine
sudo cp config/database.yml.example config/database.yml

# Modify database.yml with the correct credentials
sudo sed -i 's/adapter: mysql2/adapter: mysql/' config/database.yml
sudo sed -i 's/username: root/username: redmine/' config/database.yml
sudo sed -i 's/password: ""/password: "password"/' config/database.yml
sudo sed -i 's/database: redmine/database: redmine/' config/database.yml

# Install Redmine dependencies
sudo su - redmine -c "bundle install --without development test"

# Step 7: Generate the session store secret
echo "Generating session store secret..."
sudo su - redmine -c "RAILS_ENV=production bundle exec rake generate_secret_token"

# Step 8: Migrate the database
echo "Migrating the database..."
sudo su - redmine -c "RAILS_ENV=production bundle exec rake db:migrate"

# Step 9: Install the Redmine database schema and default data
echo "Installing database schema and default data..."
sudo su - redmine -c "RAILS_ENV=production bundle exec rake redmine:load_default_data"

# Step 10: Configure Apache
echo "Configuring Apache..."
sudo cp /opt/redmine/public/dispatch.fcgi /opt/redmine/public/dispatch.cgi
sudo chown -R redmine:redmine /opt/redmine

# Create Apache virtual host for Redmine
sudo bash -c 'cat > /etc/apache2/sites-available/redmine.conf <<EOF
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /opt/redmine/public

    RailsEnv production
    PassengerAppRoot /opt/redmine

    <Directory /opt/redmine/public>
        Allow from all
        Options -MultiViews
        Require all granted
    </Directory>
</VirtualHost>
EOF'

# Step 11: Enable the Redmine site and restart Apache
echo "Enabling Redmine site and restarting Apache..."
sudo a2ensite redmine.conf
sudo systemctl restart apache2

# Step 12: Open port 80 if needed (for firewall)
echo "Allowing HTTP through the firewall..."
sudo ufw allow 80/tcp

# Step 13: Final steps
echo "Redmine installation complete!"
echo "You can now access Redmine at http://localhost or http://your-server-ip"
