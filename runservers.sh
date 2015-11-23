# Function to issue sudo command with password
function sudo-pw {
    echo "vagrant" | sudo -S $@
}

# sudo kill `sudo lsof -t -i:8080`
# sudo kill `sudo lsof -t -i:9292`
# sudo kill `sudo lsof -t -i:8443`
# sudo kill `sudo lsof -t -i:8001`

# OpenDSA content server
cd /vagrant/OpenDSA
(setsid ./WebServer &)

sleep 2
# OpenDSA-LTI server
cd /vagrant/OpenDSA-LTI
(setsid sudo rackup config.ru &)

sleep 2
# OpenDSA-server
cd /vagrant/OpenDSA-server/ODSA-django
(setsid sudo ./runserver &)
