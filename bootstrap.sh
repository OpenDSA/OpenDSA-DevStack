#!/bin/bash

# The output of all these installation steps is noisy.
# With this utility the progress report is nice and concise.
silentInstall() {
    echo installing $1 ...
    # --quiet does not work as intended.  Directing stdin and stderr is needed for now
    sudo apt-get --yes --quiet install $1 >/dev/null 2>&1
}

silentAptUpdate() {
	echo "Doing apt-get update..."
	sudo apt-get --quiet --quiet update
}

silentAddAptRepo() {
	echo Adding Apt Repo: $1 ...
    sudo apt-add-repository --yes $1 >/dev/null 2>&1
    silentAptUpdate
}

OpenDSA=true
OpenDSA_LTI=true
codeworkout=true
echo "boostrap.sh setup: OpenDSA=$OpenDSA ; OpenDSA_LTI=$OpenDSA_LTI ; codeworkout=$codeworkout"

echo "============ Adding Swap File ============"
fallocate --length 2G /swapfile
chown root:root /swapfile # not needed since already root
chmod 0600 /swapfile
mkswap /swapfile
swapon /swapfile
# echo "Verifying..." && swapon -s
# grep -i --color swap /proc/meminfo
echo '\n/swapfile none swap defaults 0 0' >> /etc/fstab

echo "============ Updating System ============"
silentAptUpdate
echo "Doing apt-get upgrade ..."
sudo apt-get --yes --quiet --quiet upgrade >/dev/null 2>&1

# echo "QUITTING EARLY!!!!" && exit 0 # For if you want to avoid all the setup

echo "============ Installing Development Tools ============"
silentInstall build-essential
silentInstall dkms
silentInstall curl
silentInstall libxslt-dev
silentInstall libpq-dev
silentInstall libmariadbclient-dev
silentInstall libcurl4-gnutls-dev
silentInstall libevent-dev
silentInstall libffi-dev
silentInstall libssl-dev
silentInstall stunnel4
silentInstall libsqlite3-dev
silentInstall git

if [ "$OpenDSA" = true ]; then
	echo "================= Installing Python ================="
	silentInstall python3-venv # is needed for 3.8-venv
	silentInstall python3.8-venv
fi

if [ "$OpenDSA_LTI" = true ]; then
	echo "============== Installing Ruby and Gem =============="
	echo "NOTE: The bionic64 VM can install ruby2.5 immediately!  No add-repo needed!"
	echo "NOTE: But ruby2.3 -> ruby2.5 has code changes. "
	silentAddAptRepo ppa:brightbox/ruby-ng
	silentInstall ruby2.5
	silentInstall ruby2.5-dev
	update-alternatives --quiet --set ruby /usr/bin/ruby2.5
	update-alternatives --quiet --set gem /usr/bin/gem2.5
	sudo apt autoremove --yes --quiet
fi

# sudo apt-get update
# sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev
# cd
# git clone https://github.com/rbenv/rbenv.git /home/vagrant/.rbenv
# echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /home/vagrant/.bashrc
# echo 'eval "$(rbenv init -)"' >> /home/vagrant/.bashrc
# exec $SHELL
# git clone https://github.com/rbenv/ruby-build.git /home/vagrant/.rbenv/plugins/ruby-build
# echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> /home/vagrant/.bashrc
# exec $SHELL
# rbenv install 2.3.1
# rbenv global 2.3.1
# ruby -v

if [ "$OpenDSA_LTI" = true ]; then
	echo "============== Installing Bundler and Rake =================="
	# gem install bundler -N >/dev/null 2>&1  OLD
	gem install bundler --version 2.1.4 --no-document >/dev/null 2>&1
	gem install rake --version 13.0.1 >/dev/null 2>&1

	echo "============ Installing Nokogiri dependencies ============"
	silentInstall libxml2
	silentInstall libxml2-dev
	silentInstall libxslt1-dev
fi


if [ "$codeworkout" = true ] || [ "$OpenDSA_LTI" = true ]; then
	echo "============ Installing SQL and doing config ============"
	debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
	debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
	silentInstall MySQL
	silentInstall mysql-server
	silentInstall libmysqlclient-dev
	mysql -uroot -proot <<SQL
	CREATE DATABASE codeworkout DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
	CREATE DATABASE opendsa DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
	GRANT ALL PRIVILEGES ON codeworkout.* to 'codeworkout'@'localhost' IDENTIFIED BY 'codeworkout';
	FLUSH PRIVILEGES;
	GRANT ALL PRIVILEGES ON opendsa.* to 'opendsa'@'localhost'  IDENTIFIED BY 'opendsa';
	FLUSH PRIVILEGES;
SQL
fi


if [ "$OpenDSA" = true ]; then
	echo "============ Installing Nodejs And NPM ============"
	sudo apt-get --yes --quiet purge nodejs
	sudo apt-get --yes --quiet purge npm
	echo "NOTE: Node needs a update. Changing to setup_12.x seems to work fine?"
	curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
	silentInstall nodejs
	silentInstall npm # npm is already included in node12
	sudo ln --symbolic "$(which nodejs)" /usr/local/bin/node
	npm install --global jshint
	npm install --global csslint
	npm install --global jsonlint
	npm install --global uglify-js # minifies js files
	npm install --global clean-css-cli # minifies css files
	if [ "$OpenDSA_LTI" = true ]; then
		npm install --global bower
		echo "NOTE: See https://bower.io/blog/2017/how-to-migrate-away-from-bower/"
		echo "NOTE: bower is old and wants to be replaced with Yarn; can try bower-away"
	fi
fi


echo "============ Install HSTR Command History tool ============"
silentInstall libncurses5-dev
silentInstall libreadline-dev
silentAddAptRepo ppa:ultradvorka/ppa
silentInstall hstr
hh --show-configuration >> ~/.bashrc
# source home/vagrant/.bashrc  # not really needed since this script doesnt need hh or hstr


if [ "$OpenDSA_LTI" = true ]; then
	echo "============ Installing Java 8 and Ant ============"
	silentAddAptRepo ppa:webupd8team/java
	echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
	echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
	# silentInstall oracle-java8-installer # not a package anymore
	silentInstall ant
fi

cd /vagrant
echo "This is the home of our projects:"
echo | pwd
export ODSA_ENV="DEV"
echo "export ODSA_ENV=\"DEV\"" >> /home/vagrant/.bashrc
echo "echo \"ODSA_ENV variable is set to: \$ODSA_ENV\"" >> /home/vagrant/.bashrc
echo "cd /vagrant" >> /home/vagrant/.bashrc
export PYTHON="python3.8"
echo "export PYTHON=\"python3.8\"" >> /home/vagrant/.bashrc
echo "cd /vagrant" >> /home/vagrant/.bashrc

# Needed for docs generation.
update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

if [ "$OpenDSA" = true ]; then
	echo "================= Pulling OpenDSA ================="
	if [ ! -d /vagrant/OpenDSA ]; then
		git clone https://github.com/OpenDSA/OpenDSA.git /vagrant/OpenDSA
	fi
	cd /vagrant/OpenDSA
	make pull

	echo "============ Building OpenDSA's Py Venv and pip packages ============"
	cd /vagrant/OpenDSA
	make venv
	# Automatically activates the .pyVenv every login.
	echo "cd /vagrant/OpenDSA" >> /home/vagrant/.bashrc
	echo "source .pyVenv/bin/activate" >> /home/vagrant/.bashrc
fi

if [ "$codeworkout" = true ]; then
	echo "============ Pulling Code-Workout and bundle-ing ============"
	if [ ! -d /vagrant/code-workout ]; then
		git clone https://github.com/OpenDSA/code-workout.git /vagrant/code-workout
	fi
	cd /vagrant/code-workout
	git pull
	bundle install
	bundle exec rake db:populate
fi

cd /vagrant/OpenDSA/
# git checkout LTI_ruby
# cd /vagrant/OpenDSA/khan-exercises
# git checkout LTI_ruby

if [ "$OpenDSA_LTI" = true ]; then
	echo "============ Pulling OpenDSA-LTI and bundle-ing ============"
	if [ ! -d /vagrant/OpenDSA-LTI ]; then
		git clone https://github.com/OpenDSA/OpenDSA-LTI.git /vagrant/OpenDSA-LTI
		cd /vagrant/OpenDSA-LTI
		git checkout railsv6
		git pull
	fi
	cd /vagrant/OpenDSA-LTI
	echo "NOTE: bundle prefers to run as user, not root.  Use 'sudo -u vagrant bund...'' instead?"
	bundle install
	echo "NOTE: need to create database.yml, move migrations, and recreate db"
	bundle exec rake db:drop
	bundle exec rake db:create
	bundle exec rake db:schema:load
	bundle exec rake db:seed
	bundle exec rake db:populate

	echo "============ Creating links between OpenDSA-LTI and OpenDSA ============"
	ln --symbolic --force /vagrant/OpenDSA /vagrant/OpenDSA-LTI/public
	ln --symbolic --force /vagrant/OpenDSA/RST /vagrant/OpenDSA-LTI/RST
	ln --symbolic --force /vagrant/OpenDSA/config /vagrant/OpenDSA-LTI/Configuration
	rm /vagrant/OpenDSA-LTI/Configuration/config
	rm /vagrant/OpenDSA-LTI/RST/RST
	sudo bower install --allow-root
fi

echo "!!!! all set, welcome to OpenDSA project !!!!!"
