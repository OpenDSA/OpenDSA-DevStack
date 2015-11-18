# Function to issue sudo command with password
function sudo-pw {
    echo "vagrant" | sudo -S $@
}

# OpenDSA-server
cd /vagrant/OpenDSA-server/ODSA-django
sudo-pw kill `sudo lsof -t -i:8443`
sudo-pw kill `sudo lsof -t -i:8001`
setsid sudo-pw ./runserver

# OpenDSA content server
cd /vagrant/OpenDSA
sudo-pw kill `sudo lsof -t -i:8080`
setsid ./WebServer

# OpenDSA-LTI server
cd /vagrant/OpenDSA-LTI
sudo-pw kill `sudo lsof -t -i:9292`
setsid sudo-pw rackup config.ru
