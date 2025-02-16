### Defensive settings for make:
#     https://tech.davis-hansson.com/p/make/
SHELL:=bash
.ONESHELL:
.SHELLFLAGS:=-xeu -o pipefail -O inherit_errexit -c
.SILENT:
.DELETE_ON_ERROR:
MAKEFLAGS+=--warn-undefined-variables
MAKEFLAGS+=--no-builtin-rules

CURRENT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
GIT_FOLDER=$(CURRENT_DIR)/.git

PROJECT_NAME=irontreecms
STACK_NAME=cms-irontree-co-kr

.PHONY: help
help: ## This help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

## Docker stack
.PHONY: irontree-stack-start
irontree-stack-start:  ## Irontree Stack: Start Services
	@echo "Start Irontree Docker stack"
	@docker compose -p $(STACK_NAME) -f docker-compose.yml up -d
	@echo "Now visit: http://dev.irontree.co.kr"


.PHONY: irontree-stack-create-site
irontree-stack-create-site:  ## Local Stack: Create a new site
	@echo "Create a new site in the Irontree Docker stack"
	@docker compose -p $(STACK_NAME) -f docker-compose.yml exec backend ./docker-entrypoint.sh create-site
	
.PHONY: irontree-stack-status
irontree-stack-status:  ## Irontree Stack: Check Status
	@echo "Check the status of the Irontree Doc"
	@docker compose -p $(STACK_NAME) -f docker-compose.yml ps

.PHONY: irontree-stack-stop
irontree-stack-stop:  ##  Irontree Stack: Stop Services
	@echo "Stop Irontree Docker stack"
	@docker compose -p $(STACK_NAME) -f docker-compose.yml stop


.PHONY: irontree-stack-rm
irontree-stack-rm:  ## Irontree Stack: Remove Services and Volu
	@echo "Remove Irontree Docker stack"
	@docker compose -f docker-compose.yml down
	@echo "Remove local volume data"
	@docker volume rm $(STACK_NAME)_data