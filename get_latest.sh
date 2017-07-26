cd /vagrant/OpenDSA-LTI
git pull
sudo bundle install
bundle exec rake db:migrate
cd /vagrant/code-workout
git pull
sudo bundle install
bundle exec rake db:migrate
cd /vagrant/OpenDSA
make pull
cd /vagrant
./runservers.sh