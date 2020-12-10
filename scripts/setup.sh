#!/bin/bash

git clone https://github.com/OpenDSA/OpenDSA.git opendsa
git clone https://github.com/OpenDSA/OpenDSA-LTI.git opendsa-lti
git clone https://github.com/web-cat/code-workout.git

/bin/cp ./config/server.* ./code-workout/
/bin/cp ./config/codeworkout_runservers.sh ./code-workout/runservers.sh
/bin/cp ./config/codeworkout_db.yml ./code-workout/config/database.yml

#/bin/cp ./config/extrtoolembed.py ./opendsa/RST/ODSAextensions/odsa/extrtoolembed/
