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

echo -e "\n--- Setting up our MySQL user and db ---\n"
mysql -uroot -proot -e "CREATE DATABASE opendsa"
mysql -uroot -proot -e "GRANT ALL ON opendsa.* TO 'opendsa'@'localhost' IDENTIFIED BY 'opendsa'"

sudo-pw /etc/init.d/mysql restart
sudo-pw service mysql stop
sudo-pw service mysql restart


# Install OpenDSA-server
sudo-pw apt-get -y autoremove

sudo-pw apt-get -y install dkms     # For installing VirtualBox guest additions
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

sudo-pw apt-get -y update

# Clone OpenDSA-server
# sudo-pw rm -rf /vagrant/OpenDSA-server
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

# Install requirements
sudo-pw pip install -r requirements.txt

# Change stunnel.pem file permission
sudo-pw chmod 600 stunnel/stunnel.pem

# Run Django syncdb
python manage.py syncdb

# Run development server
sudo-pw kill `sudo lsof -t -i:8443`
sudo-pw kill `sudo lsof -t -i:8001`
sudo-pw ./runserver

# Clone OpenDSA
sudo-pw git clone https://github.com/OpenDSA/OpenDSA.git /vagrant/OpenDSA

# Checkout LTI branch
cd /vagrant/OpenDSA/
git checkout LTI
make pull

# Clone OpenDSA-LTI
sudo-pw git clone https://github.com/OpenDSA/OpenDSA.git /vagrant/OpenDSA-LTI

# Show commands as they are executed, useful for debugging
# turned off in some areas to avoid logging other scripts
set -v

# Store current stdout and stderr in file descriptors 3 and 4
# If breaking out of script before complete, restart terminal
# to restore proper descriptors
exec 3>&1
exec 4>&2

# Capture all output and errors in config_log.txt for debugging
# in case of errors or failed installs due to network or other issues
exec > >(tee config_log.txt)
exec 2>&1

# Start configuration
cd ~/

# add profile to bash_profile as recommended by rvm
touch ~/.bash_profile
echo "source ~/.profile" >> ~/.bash_profile

# Get mpapis' pubkey per https://rvm.io/rvm/security
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
set +v
curl -L https://get.rvm.io | bash -s stable --ruby=1.9.3
source ~/.rvm/scripts/rvm

# reload profile to set paths for gem and rvm commands
source ~/.bash_profile
set -v

# remove warning when having ruby version in Gemfile so Heroku uses correct version
rvm rvmrc warning ignore allGemfiles

# Install sqlite3 dev
sudo-pw apt-get -y install sqlite3 libsqlite3-dev

## GEMS

# install rails 3.2.16
gem install rails -v 3.2.16

# sqlite 3 gem
gem install sqlite3

# other gems: for testing and debugging....
gem install cucumber -v 1.3.8
gem install cucumber-rails -v 1.3.1
gem install cucumber-rails-training-wheels
gem install rspec
gem install rspec-rails
gem install autotest
gem install spork
gem install metric_fu
gem install debugger
gem install timecop -v 0.6.3
gem install chronic -v 0.9.1
# for app development...
gem install omniauth
gem install omniauth-twitter
gem install nokogiri
gem install themoviedb -v 0.0.17
gem install ruby-graphviz
gem install reek
gem install flog
gem install flay
set +v
rvm 1.9.3 do gem install jquery-rails
set -v
gem install fakeweb

wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh

# Restore stdout and stderr and close file descriptors 3 and 4
exec 1>&3 3>&-
exec 2>&4 4>&-

# turn off echo
set +v

# NOTE: you will need to run `source ~/.rvm/scripts/rvm` or similar (see the output from the script) to have access to your gems etc.
