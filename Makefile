DOCKER ?= docker

image:
	$(DOCKER) build -t ssh-agent:alpine-3.18.4 -f Dockerfile .
