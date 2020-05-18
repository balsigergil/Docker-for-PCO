user := $(shell id -u)
group := $(shell id -g)
dc := USER_ID=$(user) GROUP_ID=$(group) docker-compose

.DEFAULT_GOAL := help
.PHONY: help
help: ## Affiche cette aide
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: qt
qt: ## Lance Qt
	$(dc) run --rm qt

.PHONY: shell
shell: ## Lance le shell du conteneur Qt
	$(dc) run --rm qt bash

.PHONY: root
root: ## Lance le shell du conteneur Qt en root
	$(dc) run --rm -u 0 qt bash

.PHONY: build
build: ## Construit l'image
	$(dc) build

.PHONY: update
update: ## Update PCO syncro
	$(dc) run --rm qt ./entrypoint.sh update
	$(dc) build

.PHONY: mrproper
mrproper: ## Supprime les volumes et les images
	$(dc) down -v
	docker image rm pco-qt:2020
	docker image prune -f
