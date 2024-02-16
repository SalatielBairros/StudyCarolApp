PYLINT = flake8
PYLINTFLAGS = -rn
PYTHONFILES := $(wildcard *.py)
SRCFOLDER = src
DOCKER_TAG = studyapp-alg_studyapp:0.1.0

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

help: ## Show this help message
	@echo "studyapp Makefile help.\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

init: ## Install all package dependencies
	pip install -r requirements.txt

test: ## Runs all project test suite, recording all test converage data
	PYTHONPATH=${PWD}/${SRCFOLDER}:${PYTHONPATH} pytest --cov=${SRCFOLDER}/ tests/

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
code_scan: ## Execute a Code Qualiry scan and send the data to SonarQube server
	@echo "~~~ Code Quality Scan"
	sonar-scanner -Dsonar.projectKey=studyapp-alg_studyapp -Dsonar.sources=${SRCFOLDER} -Dsonar.host.url=${SONAR_URL} -Dsonar.login=${SONAR_TOKEN} -Dsonar.branch.name=${BUILDKITE_BRANCH} -Dsonar.python.coverage.reportPaths="coverage-reports/coverage.xml"

lint: ## Lint all code for best practicies
	flake8 ./${SRCFOLDER} ./tests

run: ## Runs the online app locally on http://localhost:5000
	# PYTHONPATH=${PWD}/${SRCFOLDER}:${PYTHONPATH} PYTHONUNBUFFERED=1 FLASK_DEBUG=1 gunicorn -w 1 -b :5000 ${SRCFOLDER}.alg_studyapp:application
	PYTHONPATH=${PWD}/${SRCFOLDER}:${PYTHONPATH} PYTHONUNBUFFERED=1 FLASK_DEBUG=1 FLASK_ENV=development python ${SRCFOLDER}/alg_studyapp.py

build_ci: ## Build CI Docker Image
	docker build -f docker/ci_image/Dockerfile -t ci_image .

venv: ## Create the virtualenv for this Carol App
	python3 -m venv .venv
	source .venv/bin/activate && pip install --upgrade pip

all_tests: tests coverage code_scan ## Runs all test related tasks

dist: clean ## Create the dist file to deploy on Carol
	@mkdir dist
	@mkdir dist/ai-script
	@cp ${SRCFOLDER}/manifest.json dist/ai-script
	@cd dist && zip -r studyapp.zip ai-script/*

docker_image: ## Build studyapp-alg_studyapp:0.1.0 Carol app docker image
	@podman build -t studyapp-alg_studyapp:0.1.0 .

docker_run: ## Runs studyapp-alg_studyapp:0.1.0 Carol app docker image
	@podman run --rm -it -p 5000:5000 studyapp-alg_studyapp:0.1.0

docker_run_dev: ## Runs studyapp-alg_studyapp:0.1.0 Carol app docker image in Development mode using local code
	@podman run --rm -it --env PYTHONPATH=. --env PYTHONUNBUFFERED=1 --env FLASK_DEBUG=1 --env FLASK_ENV=development -p 127.0.0.1:5000:5000 -v ${PWD}:/app studyapp-alg_studyapp:0.1.0 python src/alg_studyapp.py

