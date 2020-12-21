#!/bin/bash

docker-compose exec opendsa-lti rake db:populate
docker-compose exec codeworkout rake db:create
docker-compose exec codeworkout rake db:populate
