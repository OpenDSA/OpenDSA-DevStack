# OpenDSA content server
cd /vagrant/OpenDSA
sudo lsof -t -i tcp:8080 | xargs kill -9
(setsid python3 server.py &)

sleep 2
# OpenDSA-LTI server
cd /vagrant/OpenDSA-LTI
sudo lsof -t -i tcp:9292 | xargs kill -9
(setsid bundle exec thin start --ssl --ssl-key-file server.key --ssl-cert-file server.crt -p 9292 &)

sleep 2
# OpenDSA-LTI server
cd /vagrant/OpenDSA-LTI
(setsid bundle exec rake jobs:work &)

sleep 2
# code-workout
cd /vagrant/code-workout
sudo lsof -t -i tcp:9200 | xargs kill -9
(setsid bundle exec thin start --ssl --ssl-key-file server.key --ssl-cert-file server.crt -p 9200 &)

# sleep 2
# # OpenPOP
# cd /vagrant/OpenPOP
# (setsid bundle exec thin start --ssl --ssl-key-file server.key --ssl-cert-file server.crt -p 9210 &)
