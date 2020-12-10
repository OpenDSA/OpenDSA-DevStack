#!/bin/bash

cd opendsa-lti
git pull
cd ../opendsa
make pull
cd ../code-workout
git stash
git pull
git stash pop
cd ..
