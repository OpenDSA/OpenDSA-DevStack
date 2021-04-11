env ?= dev

.DEFAULT_GOAL := help

ifeq ($(filter $(env),dev prod),)
  $(error the env variable is invalid. Must be one of <prod|dev>)
endif

.PHONY: opendsa opendsa-lti code-workout openPOP

opendsa: ## Inits the opendsa project as a submodule and updates
	### git submodule add https://github.com/OpenDSA/OpenDSA.git opendsa
	git submodule update --init --remote -- opendsa
	cd opendsa && git checkout master && cd ..
	# cp config/extrtoolembed.py opendsa/RST/ODSAextensions/odsa/extrtoolembed/

opendsa-lti: ## Inits the opendsa-lti project as a submodule and updates
	### git submodule add https://github.com/OpenDSA/OpenDSA-LTI.git opendsa-lti
	git submodule update --init --remote -- opendsa-lti
	cd opendsa-lti && git checkout master && cd ..

code-workout: ## Inits the web-cat/code-workout project as a submodule and updates (+ some configs)
	### git submodule add -b staging https://github.com/web-cat/code-workout.git
	git submodule update --init --remote -- code-workout
	cd code-workout && git checkout staging && cd ..
	@echo "### Note: this may not be the master branch!!!"
	cp config/codeworkout_runservers.sh code-workout/runservers.sh
	cp config/codeworkout_db.yml code-workout/config/database.yml
	cp config/server.* code-workout/

openpop: ## Inits the openpop project as a submodule and updates
	### git submodule add https://github.com/OpenDSA/OpenPOP.git openpop
	git submodule update --init --remote -- openpop
	cd openpop && git checkout master && cd ..

.PHONY: clean update help
clean: ## De-inits all submodule repositories
	-git submodule deinit -f -- opendsa
	-git submodule deinit -f -- opendsa-lti
	-git submodule deinit -f -- code-workout
	-git submodule deinit -f -- openpop

update: ## Updates all initialized submodules
	git submodule update --remote


database: ## Sets up the OpenDSA and CodeWorkout databases
	docker-compose exec opendsa-lti rake db:populate
	docker-compose exec codeworkout rake db:create
	docker-compose exec codeworkout rake db:populate

help: ## This help dialog
	@echo
	@echo Wanting into this container? Try: docker-compose run setup bash
	@awk 'BEGIN {FS = ":.*##"; printf "Usage:\n  make \033[36m<target>\033[0m\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
