include Makefile.prod

env ?= dev

.DEFAULT_GOAL := help

ifeq ($(filter $(env),dev prod),)
  $(error the env variable is invalid. Must be one of <prod|dev>)
endif

SUBPROJECTS = opendsa opendsa-lti code-workout openpop

.PHONY: $(SUBPROJECTS)

opendsa: ## Inits the opendsa project as a subproject
	rm -rf opendsa
	git clone https://github.com/OpenDSA/OpenDSA.git opendsa
	# cp config/extrtoolembed.py opendsa/RST/ODSAextensions/odsa/extrtoolembed/

opendsa-lti: ## Inits the opendsa-lti and opendsa projects as subprojects
	cp env.example .env
	rm -rf opendsa-lti
	git clone https://github.com/OpenDSA/OpenDSA-LTI.git opendsa-lti
	rm -rf opendsa
	git clone https://github.com/OpenDSA/OpenDSA.git opendsa

code-workout: ## Inits the web-cat/code-workout project as a subproject (+ do some config)
	rm -rf code-workout
	git clone --branch staging https://github.com/web-cat/code-workout.git
	@echo "### Note: this ^^^ may not be the master branch!!!"
	cp config/codeworkout_db.yml code-workout/config/database.yml

openpop: ## Inits the openpop project as a subproject
	rm -rf openpop
	git clone https://github.com/OpenDSA/OpenPOP.git openpop


.PHONY: clean gitPull gitStatus help
clean: ## Clears out all subproject repositories, and resets to placeholders
	-rm -rf $(SUBPROJECTS)
	-git checkout -- $(SUBPROJECTS)

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
