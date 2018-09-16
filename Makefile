#IMAGE_VERSION = `git reflog -n 1 | awk '{ print $$1 }'`
IMAGE_VERISON = latest
ORG = binarymachines
PROJECT = amc-artemis
COMPOSE = docker-compose -p "${PROJECT}"
HOST_UID = `id -u`
HOST_GID = `id -g`
#DOCKER_PROCESSES = $(docker ps -a -f status=exited | awk 'FNR == 2 {print}')
#DOCKER_IMAGES = $(shell docker images -q | awk 'FNR == 2 {printf "%s:%s\n", $$1, $$2}')


# ----- Builds and Deployments -----

docker-build: 
	docker build -t ${ORG}/${PROJECT} -f conf/Dockerfile .

docker-build-clean:
	docker build -t ${ORG}/${PROJECT} --no-cache -f conf/Dockerfile .

docker-pull: FORCE
	docker pull ${ORG}/${PROJECT}:${IMAGE_VERSION}

docker-pull-all: docker-pull FORCE
	docker pull couchbase
	docker pull postgres

docker-push:
	docker push ${ORG}/${PROJECT}

#docker-tag-latest: FORCE
#	docker tag ${ORG}/${PROJECT}:${IMAGE_VERSION} stripe_listener:latest

docker-test:
	./docker-test.sh 

docker-destroy:
	-docker images | grep artemis | awk '{print $$3}' | xargs --no-run-if-empty docker rmi -f

up: regen
	${COMPOSE} up -d

down: FORCE
	${COMPOSE} down --remove-orphans -v

docker-rm:
	docker-compose rm -f

bounce: down docker-rm up


docker-login:
	${COMPOSE} run --rm listener /bin/bash

test: 
	python -m unittest discover tests


#---------------- local development


regen:
	PYTHONPATH=./src pipenv run routegen -e src/striped_init.yaml > src/striped.py

run:
	pipenv run python src/striped.py --configfile src/striped_init.yaml

FORCE:  # https://www.gnu.org/software/make/manual/html_node/Force-Targets.html#Force-Targets
