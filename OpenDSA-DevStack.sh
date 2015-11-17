#!/usr/bin/env bash

# Get password to be used with sudo commands
echo -n "Enter password to be used for sudo commands:"
read -s password

# Function to issue sudo command with password
function sudo-pw {
    echo $password | sudo -S $@
}

# Start configuration

# Install and configure mysql-server
sudo-pw apt-get -y update
sudo-pw debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo-pw debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
sudo-pw apt-get -y install mysql-server
sed -i "s/^bind-address/#bind-address/" /etc/mysql/my.cnf
mysql -u root -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION; FLUSH PRIVILEGES;"

mysql -uroot -proot -e "CREATE DATABASE opendsa"
mysql -uroot -proot -e "GRANT ALL ON opendsa.* TO 'opendsa'@'localhost' IDENTIFIED BY 'opendsa'"

sudo-pw service mysql stop
sudo-pw service mysql start

sudo-pw apt-get -y autoremove

sudo-pw apt-get -y install dkms curl screen libxml2-dev libxslt-dev nodejs git libpq-dev vim emacs python python-feedvalidator python-software-properties libmysqlclient-dev libmariadbclient-dev libcurl4-gnutls-dev python-pip libevent-dev libffi-dev libssl-dev python-dev build-essential stunnel4

sudo-pw apt-get -y update

# Clone OpenDSA-server
sudo-pw git clone https://github.com/OpenDSA/OpenDSA-server.git /vagrant/OpenDSA-server

# Create link to assets
ln -s /vagrant/OpenDSA-server/ODSA-django/assets/* /vagrant/OpenDSA-server/ODSA-django/static

# Checkout NewKA branch
cd /vagrant/OpenDSA-server/
git checkout NewKA
cd /vagrant/OpenDSA-server/ODSA-django

# Create media folder
sudo-pw mkdir /vagrant/OpenDSA-server/ODSA-django/media
sudo-pw touch /vagrant/OpenDSA-server/ODSA-django/media/daily_stats.json

# Change stunnel.pem file permission
sudo-pw chmod 600 stunnel/stunnel.pem

# Install requirements
sudo-pw pip install -r requirements.txt

# Run Django syncdb
python manage.py syncdb

# Clone OpenDSA
sudo-pw git clone https://github.com/OpenDSA/OpenDSA.git /vagrant/OpenDSA

# Checkout LTI branch
cd /vagrant/OpenDSA/
git checkout LTI
make pull

sudo-pw apt-get -y install python-sphinx
sudo-pw curl -sL https://deb.nodesource.com/setup | sudo bash -
sudo-pw apt-get -y install nodejs
sudo-pw apt-get -y install uglifyjs
sudo-pw apt-get -y install uglifycss
sudo-pw ln -s /usr/bin/nodejs /usr/bin/node
sudo-pw ln -s /usr/bin/nodejs /usr/sbin/node
sudo-pw npm install -g jshint
sudo-pw npm install -g csslint
sudo-pw pip install -r requirements.txt

# Clone OpenDSA-LTI
sudo-pw git clone https://github.com/OpenDSA/OpenDSA-LTI.git /vagrant/OpenDSA-LTI
cd /vagrant/OpenDSA-LTI
git checkout dev

# add profile to bash_profile as recommended by rvm
cd ~/
touch ~/.bash_profile
echo "source ~/.profile" >> ~/.bash_profile

# Get mpapis' pubkey per https://rvm.io/rvm/security
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -L https://get.rvm.io | bash -s stable --ruby=1.9.3
source ~/.rvm/scripts/rvm

# reload profile to set paths for gem and rvm commands
source ~/.bash_profile

## GEMS
gem install bundler

cd /vagrant/OpenDSA-LTI
sudo bundle install

su -c 'bash /vagrant/runservers.sh' vagrant