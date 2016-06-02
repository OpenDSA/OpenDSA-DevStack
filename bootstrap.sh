# The output of all these installation steps is noisy. With this utility
# the progress report is nice and concise.
function install {
    echo installing $1
    shift
    apt-get -y install "$@" >/dev/null 2>&1
}

echo adding swap file
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap defaults 0 0' >> /etc/fstab

echo updating system packages
apt-add-repository -y ppa:brightbox/ruby-ng >/dev/null 2>&1
apt-get -y update >/dev/null 2>&1

install 'development tools' build-essential  dkms curl libxslt-dev libpq-dev python-dev python-pip python-feedvalidator python-software-properties python-sphinx libmariadbclient-dev libcurl4-gnutls-dev libevent-dev libffi-dev libssl-dev stunnel4 libsqlite3-dev

install Ruby ruby2.3 ruby2.3-dev
update-alternatives --set ruby /usr/bin/ruby2.3 >/dev/null 2>&1
update-alternatives --set gem /usr/bin/gem2.3 >/dev/null 2>&1

echo installing Bundler
gem install bundler -N >/dev/null 2>&1

install Git git

debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
install MySQL mysql-server libmysqlclient-dev
mysql -uroot -proot <<SQL
CREATE DATABASE opendsa DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
CREATE DATABASE opendsa_lti DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL PRIVILEGES ON opendsa.* to 'opendsa'@'localhost' IDENTIFIED BY 'opendsa';
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON opendsa_lti.* to 'opendsa'@'localhost'  IDENTIFIED BY 'opendsa';
FLUSH PRIVILEGES;
SQL

install 'Nokogiri dependencies' libxml2 libxml2-dev libxslt1-dev
install 'ExecJS runtime' nodejs npm uglifyjs
curl -sL https://deb.nodesource.com/setup | sudo bash -
ln -s /usr/bin/nodejs /usr/bin/node
ln -s /usr/bin/nodejs /usr/sbin/node
npm install -g jshint
npm install -g csslint
npm install -g bower

# Needed for docs generation.
update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

# install hh tool
cd
apt-add-repository -y ppa:ultradvorka/ppa
apt-get update
apt-get install -y hh

apt-get install -y libncurses5-dev libreadline-dev
wget https://github.com/dvorka/hstr/releases/download/1.10/hh-1.10-src.tgz
tar xf hh-1.10-src.tgz
cd hstr
./configure && make && sudo make install

hh --show-configuration >> ~/.bashrc
source ~/.bashrc

# install Java 8 and Ant
sudo apt-add-repository -y ppa:webupd8team/java
sudo apt-get update
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt-get install -y oracle-java8-installer
sudo apt-get install -y ant

# Clone OpenDSA-server
if [ ! -d /vagrant/OpenDSA-server ]; then
  git clone https://github.com/OpenDSA/OpenDSA-server.git /vagrant/OpenDSA-server
fi
git pull

# Change stunnel.pem file permission
chmod 600 /vagrant/OpenDSA-server/ODSA-django/stunnel/stunnel.pem

# Install requirements
cd /vagrant/OpenDSA-server/ODSA-django
pip install -r requirements.txt

# Run Django syncdb
python manage.py syncdb --noinput
echo "from django.contrib.auth.models import User; User.objects.create_superuser('opendsa', 'admin@example.com', 'opendsa')" | python manage.py shell

# Clone OpenDSA
if [ ! -d /vagrant/OpenDSA ]; then
  git clone https://github.com/OpenDSA/OpenDSA.git /vagrant/OpenDSA
fi

# Checkout LTI_ruby branch
cd /vagrant/OpenDSA/
git checkout LTI_ruby
make pull
pip install -r requirements.txt --upgrade


# Clone OpenDSA-LTI
if [ ! -d /vagrant/OpenDSA-LTI ]; then
  git clone https://github.com/OpenDSA/OpenDSA-LTI.git /vagrant/OpenDSA-LTI
fi
git pull

cd /vagrant/OpenDSA-LTI
git checkout RailsConfigIntg
bundle install
rake db:reset_populate

# Create link to OpenDSA
ln -s /vagrant/OpenDSA /vagrant/OpenDSA-LTI/public
ln -s /vagrant/OpenDSA/RST /vagrant/OpenDSA-LTI/RST
ln -s /vagrant/OpenDSA/config /vagrant/OpenDSA-LTI/Configuration
rm /vagrant/OpenDSA-LTI/Configuration/config
rm /vagrant/OpenDSA-LTI/RST/RST
sudo bower install --allow-root

echo 'all set, welcome to OpenDSA project!'