PYLINT = flake8
PYLINTFLAGS = -rn
PYTHONFILES := $(wildcard *.py)

IMAGE = batchstudyproject-batchstudyproject_algorithm:0.1.0
APP = dev
OPERATOR ?= api.operator.carol.ai
ENVIRONMENT ?= labs-ai-apps-production

USER ?=
ID ?=
GHTOKEN ?=


ifeq ($(OS),Windows_NT)
	OPEN := start
else
	UNAME := $(shell uname -s)
	ifeq ($(UNAME),Linux)
		OPEN := xdg-open
	endif
	ifeq ($(UNAME),Darwin)
		OPEN := open
	endif
endif

.PHONY: help

.check-env:
	@test $${USER?Please set environment variable USER}
	@test $${ID?Please set environment variable ID}
	@test $${GHTOKEN?Please set environment variable GHTOKEN}

help: ## Show this help message
	@echo "batchstudyproject Makefile help.\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

init: ## Install all package dependencies
	pip install -r requirements.txt

test: ## Runs all project test suite, recording all test converage data
	pytest --cov=batchstudyproject tests/

coverage: ## Create XML and HTML Test coverare report.
	coverage xml -o coverage-reports/coverage.xml
	coverage3 html

htmlcov: coverage ## Opens the current test coverage report on the default browser
	$(OPEN) htmlcov/index.html

clean: ## Cleans all temporary and preprocessed files
	rm -rf dist
	find . -type f -name '*.py[co]' -delete -o -type d -name __pycache__ -delete
	rm -rf htmlcov/*

dev: ## Install all development packages dependencies
	pip install -r requirements-dev.txt

docs: ## Compile all package documentation in HTML format
	$(MAKE) -C docs html

lint: ## Lint all code for best practicies
	flake8 ./batchstudyproject ./tests

run_luigi: ## Runs the Batch process locally using a Luigi local scheduler
	python3 -m luigi --module batchstudyproject.batchstudyproject_algorithm main.runMe --local-scheduler

run: ## Runs the Batch process locally
	python3 -m batchstudyproject.batchstudyproject_algorithm

build_ci: ## Build CI Docker Image
	docker build -f docker/ci_image/Dockerfile -t ci_image .

venv: ## Create the virtualenv for this Carol App
	python3 -m venv .venv
	source .venv/bin/activate && pip install --upgrade pip

all_tests: tests coverage code_scan ## Runs all test related tasks

docker_image: ## Build the Carol App docker image
	docker build -t ${IMAGE} .

dist: clean ## Create the dist file to deploy on Carol
	@mkdir dist
	@mkdir dist/ai-script
	@cp batchstudyproject/manifest.json dist/ai-script
	@cd dist && zip -r batchstudyproject.zip ai-script/*
