env ?= dev

.DEFAULT_GOAL := help

ifeq ($(filter $(env),dev prod),)
  $(error the env variable is invalid. Must be one of <prod|dev>)
endif

SUBPROJECTS = opendsa opendsa-lti code-workout openPOP

.PHONY: opendsa opendsa-lti code-workout openPOP

opendsa: ## Inits the opendsa project as a subproject and updates
	-mv opendsa/devstackPlaceholder.md opendsa.devstackPlaceholder.md
	git clone https://github.com/OpenDSA/OpenDSA.git opendsa
	-mv opendsa.devstackPlaceholder.md opendsa/devstackPlaceholder.md
	# cp config/extrtoolembed.py opendsa/RST/ODSAextensions/odsa/extrtoolembed/

opendsa-lti: ## Inits the opendsa-lti project as a subproject and updates
	-mv opendsa-lti/devstackPlaceholder.md opendsa-lti.devstackPlaceholder.md
	git clone https://github.com/OpenDSA/OpenDSA-LTI.git opendsa-lti
	-mv opendsa-lti.devstackPlaceholder.md opendsa-lti/devstackPlaceholder.md

code-workout: ## Inits the web-cat/code-workout project as a subproject and updates (+ some configs)
	-mv code-workout/devstackPlaceholder.md code-workout.devstackPlaceholder.md
	git clone --branch staging https://github.com/web-cat/code-workout.git
	@echo "### Note: this  ^^^ may not be the master branch!!!"
	-mv code-workout.devstackPlaceholder.md code-workout/devstackPlaceholder.md
	cp config/codeworkout_runservers.sh code-workout/runservers.sh
	cp config/codeworkout_db.yml code-workout/config/database.yml
	cp config/server.* code-workout/

openpop: ## Inits the openpop project as a subproject and updates
	-mv openpop/devstackPlaceholder.md openpop.devstackPlaceholder.md
	git clone https://github.com/OpenDSA/OpenPOP.git openpop
	-mv openpop.devstackPlaceholder.md openpop/devstackPlaceholder.md

.PHONY: clean update help
clean: ## Clears out all subproject repositories, and resets to placeholders
	-rm -rf $(SUBPROJECTS)
	-git checkout -- opendsa/*
	-git checkout -- opendsa-lti/*
	-git checkout -- code-workout/*
	-git checkout -- openpop/*

database: ## Sets up the OpenDSA and CodeWorkout databases
	docker-compose exec opendsa-lti rake db:populate
	docker-compose exec code-workout rake db:create
	docker-compose exec code-workout rake db:populate

help: ## This help dialog
	@echo
	@echo Wanting into this container? Try: docker-compose run setup bash
	@awk 'BEGIN {FS = ":.*##"; printf "Usage:\n  make \033[36m<target>\033[0m\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
