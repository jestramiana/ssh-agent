# ssh-agent

ssh-agent in a container.

Forked from <https://github.com/whilp/ssh-agent>

## Usage

### Quick restart

If yoy have already created the `ssh-agent` container following next sections, you can shorten the process to something like this:

```shell
./docker-start.sh
./docker-run-setter.sh ssh/keys/id_ed25519
```

Otherwise, read on...

### Build the image

Execute `make` on the host.

### Run a long-lived container named `ssh-agent`. 

This container declares a volume that hosts the agent's socket so that other invocations of the `ssh` client can interact with it. Specify a UID if you would like non-root `ssh` clients in other containers to be able to connect.

```console
docker run -d -v ssh-agent-data:/ssh-agent-data --name=ssh-agent ssh-agent
```

Or simply execute the `docker-run-daemon.sh` script on the host machine.

### Add your ssh keys

Run a temporary container which has access to both the volumes from the long-lived `ssh-agent` container as well as a volume mounted from your host that includes your SSH keys. This container will only be used to load the keys into the long-lived `ssh-agent` container. Run the following command once for each key you wish to make available through the `ssh-agent` (in this example, your SSH keys should be located on your local host directory, under `./ssh/keys`):

```console
docker run --rm -v ssh-agent-data:/ssh-agent-data -v ./ssh:/ssh-config:ro -it ssh-agent ssh-add /ssh-config/keys/id_ed25519
```

Or simply execute the `docker-run-setter.sh` script on the host machine.

### Access via other containers

Now, other containers can access the keys via the `ssh-agent` by setting the `SSH_AUTH_SOCK` environment variable. For convenience, containers that have access to the volume containing `SSH_AUTH_SOCK` can configure their environment using `runit`'s `chpst` tool:

```console
docker run --rm -v ssh-agent-data:/ssh-agent-data -it alpine:3.18.4 /bin/sh -c "apk --update --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing add runit && chpst -e /ssh-agent-data/env /usr/bin/env | grep SSH_AUTH_SOCK"

SSH_AUTH_SOCK=/ssh-agent-data/auth/sock
```

## Examples

### List Keys

```console
docker run --rm -it -v ssh-agent-data:/ssh-agent-data -e SSH_AUTH_SOCK=/ssh-agent-data/auth/sock debian /bin/bash -c "apt-get update && apt-get install -y openssh-client && ssh-add -l"
```

## Notes

This container provides `ssh-agent` support; other common `ssh` functionality (including `known_hosts` management) is out of scope.

## Compatibility

This approach has been tested on:

- Docker for Mac 4.25.1 on macOS Sonoma 14.1.1, x86_64
- Docker engine 20.10.17 on Linux 5.4.215, arm64

## TODO

- Use Docker Compose
