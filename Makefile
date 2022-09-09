.POSIX:

all: help

.PHONY: galaxy
galaxy: ## Install ansible dependent roles	
	ansible-galaxy install --force -r requirements.yaml


.PHONY: enable_playbook_debug
enable_playbook_debug =
ifeq ($(debug),true)
	debug_playbook=-vvvv
endif

.PHONY: limit_playbook_inventory
limit_playbook_inventory =
ifndef $(limit)
	limit_playbook=--limit=$(limit)
endif

.PHONY: lint
lint: ## Lint code
	yamllint . && \
  	ansible-lint --exclude ~/.ansible/roles

.PHONY: nethermind
nethermind: $(enable_playbook_debug) $(limit_playbook_inventory) ## Install nethermind on servers
	ansible-playbook -i ./inventories/ ./provision.yaml $(debug_playbook)$(limit_playbook_inventory)  --tags nethermind | tee ansible-log-`date +%Y%m%d-%H%M%S`.log

.PHONY: haproxy
haproxy: $(enable_playbook_debug) $(limit_playbook_inventory) ## Install nethermind on servers
	ansible-playbook -i ./inventories/ ./provision.yaml $(debug_playbook) $(limit_playbook) --tags haproxy | tee ansible-log-`date +%Y%m%d-%H%M%S`.log

.PHONY: install
install: nethermind haproxy

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
