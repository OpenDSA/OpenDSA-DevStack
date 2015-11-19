# Function to issue sudo command with password
function sudo-pw {
    echo "vagrant" | sudo -S $@
}

# OpenDSA content server
cd /vagrant/OpenDSA
sudo-pw kill `sudo lsof -t -i:8080`
(setsid ./WebServer &)

sleep 5
# OpenDSA-LTI server
cd /vagrant/OpenDSA-LTI
sudo-pw kill `sudo lsof -t -i:9292`
(setsid rackup config.ru &)

sleep 5
# OpenDSA-server
cd /vagrant/OpenDSA-server/ODSA-django
sudo-pw kill `sudo lsof -t -i:8443`
sudo-pw kill `sudo lsof -t -i:8001`
(setsid sudo ./runserver &)
