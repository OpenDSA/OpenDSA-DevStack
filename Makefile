env ?= dev

.DEFAULT_GOAL := help

ifeq ($(filter $(env),dev prod),)
  $(error the env variable is invalid. Must be one of <prod|dev>)
endif

SUBPROJECTS = opendsa opendsa-lti code-workout openpop

.PHONY: opendsa opendsa-lti code-workout openpop

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
	@echo "### Note: this ^^^ may not be the master branch!!!"
	git checkout -- code-workout/devstackPlaceholder.md
	-mv code-workout.devstackPlaceholder.md code-workout/devstackPlaceholder.md
	cp config/codeworkout_db.yml code-workout/config/database.yml

openpop: ## Inits the openpop project as a subproject and updates
	-mv openpop/devstackPlaceholder.md openpop.devstackPlaceholder.md
	git clone https://github.com/OpenDSA/OpenPOP.git openpop
	-mv openpop.devstackPlaceholder.md openpop/devstackPlaceholder.md

.PHONY: clean update gitPull gitStatus help
clean: ## Clears out all subproject repositories, and resets to placeholders
	-rm -rf $(SUBPROJECTS)
	-git checkout -- opendsa/*
	-git checkout -- opendsa-lti/*
	-git checkout -- code-workout/*
	-git checkout -- openpop/*

gitPull: ## Git pull on each of the cloned subprojects (but NOT DevStack itself)
	if test -d opendsa/.git; then cd opendsa; git pull; fi
	if test -d opendsa-lti/.git; then cd opendsa-lti; git pull; fi
	if test -d code-workout/.git; then cd code-workout; git pull; fi
	if test -d openpop/.git; then cd openpop; git pull; fi

gitStatus: ## Git status on each of the cloned subprojects (but NOT DevStack itself)
	if test -d opendsa/.git; then cd opendsa; git status; fi
	if test -d opendsa-lti/.git; then cd opendsa-lti; git status; fi
	if test -d code-workout/.git; then cd code-workout; git status; fi
	if test -d openpop/.git; then cd openpop; git status; fi


help: ## This help dialog
	@echo
	@echo Wanting into this container? Try: docker-compose run setup bash
	@awk 'BEGIN {FS = ":.*##"; printf "Usage:\n  make \033[36m<target>\033[0m\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
