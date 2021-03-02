
#PYTHON:=python
REGISTRY:=npodewitz
IMAGE_NAME:=landing_page
CONTAINER_NAME:=${IMAGE_NAME}
DOCKER_RUN_ARGS:=-it --rm -p 8000:8000 --name ${CONTAINER_NAME} -v /var/run/docker.sock:/tmp/docker.sock:ro -e DOCKER_HOST=unix://tmp/docker.sock

.PHONY: build build-nc docker-run


build:
	@echo "Building docker image..."
	docker build -t ${IMAGE_NAME} .
	docker tag ${IMAGE_NAME} ${REGISTRY}/${IMAGE_NAME}:latest

build-nc:
	@echo "Building docker image without cache..."
	docker build --no-cache -t ${IMAGE_NAME} .
	docker tag ${IMAGE_NAME} ${REGISTRY}/${IMAGE_NAME}:latest

docker-run: build
	@echo "Running docker container..."
	docker run ${DOCKER_RUN_ARGS} landing_page:latest
