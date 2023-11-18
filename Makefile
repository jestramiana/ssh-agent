DOCKER ?= docker

image:
	$(DOCKER) build -t ssh-agent -f Dockerfile .
