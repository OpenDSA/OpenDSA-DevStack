#!/usr/bin/env bash

# Function to issue sudo command with password
function sudo-pw {
    echo "vagrant" | sudo -S $@
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

# Install OpenDSA-server
sudo-pw apt-get -y autoremove

sudo-pw apt-get -y install dkms
sudo-pw apt-get -y install curl
sudo-pw apt-get -y install screen
sudo-pw apt-get -y install libxml2-dev libxslt-dev
sudo-pw apt-get -y install nodejs
sudo-pw apt-get -y install git
sudo-pw apt-get -y install libpq-dev
sudo-pw apt-get -y install vim
sudo-pw apt-get -y install emacs
sudo-pw apt-get -y install python
sudo-pw apt-get -y install python-feedvalidator
sudo-pw apt-get -y install python-software-properties
sudo-pw apt-get -y install libmysqlclient-dev
sudo-pw apt-get -y install libmariadbclient-dev
sudo-pw apt-get -y install libcurl4-gnutls-dev
sudo-pw apt-get -y install python-pip
sudo-pw apt-get -y install libevent-dev
sudo-pw apt-get -y install libffi-dev
sudo-pw apt-get -y install libssl-dev
sudo-pw apt-get -y install python-dev
sudo-pw apt-get -y install build-essential
sudo-pw apt-get -y install stunnel4
sudo-pw apt-get -y install default-jre

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

# Create Django superuser
# echo "from django.contrib.auth.models import User; User.objects.create_superuser('opendsa', 'opendsa@opendsa.com', 'opendsa')" | python manage.py shell

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
sudo-pw pip install -r requirements.txt --upgrade

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
sudo-pw gem install bundler

cd /vagrant/OpenDSA-LTI
sudo-pw bundle install

# Create link to OpenDSA
ln -s /vagrant/OpenDSA /vagrant/OpenDSA-LTI/public

bash /vagrant/runservers.sh