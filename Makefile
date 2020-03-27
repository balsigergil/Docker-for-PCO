user := $(shell id -u)
group := $(shell id -g)
dc := USER_ID=$(user) GROUP_ID=$(group) docker-compose

.DEFAULT_GOAL := help
.PHONY: help
help: ## Affiche cette aide
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: up
up: ## Lance Qt
	$(dc) up

.PHONY: build
build: ## Construit l'image
	$(dc) build

.PHONY: clean
clean: ## Supprime le conteneur Qt
	$(dc) down