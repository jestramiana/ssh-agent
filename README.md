# ssh-agent

ssh-agent in a container.

Forked from <https://github.com/whilp/ssh-agent>

## Usage

### Run a long-lived container named `ssh-agent`. 

This container declares a volume that hosts the agent's socket so that other invocations of the `ssh` client can interact with it. Specify a UID if you would like non-root `ssh` clients in other containers to be able to connect.

```console
docker run -d -v ssh-agent-data:/ssh-agent-data --name=ssh-agent ssh-agent
```

### Add your ssh keys

Run a temporary container which has access to both the volumes from the long-lived `ssh-agent` container as well as a volume mounted from your host that includes your SSH keys. This container will only be used to load the keys into the long-lived `ssh-agent` container. Run the following command once for each key you wish to make available through the `ssh-agent`:

```console
docker run --rm -v ssh-agent-data:/ssh-agent-data -v ./ssh:/ssh-config:ro -it ssh-agent ssh-add /ssh-config/keys/id_ed25519
```

### Access via other containers

Now, other containers can access the keys via the `ssh-agent` by setting the `SSH_AUTH_SOCK` environment variable. For convenience, containers that have access to the volume containing `SSH_AUTH_SOCK` can configure their environment using `runit`'s `chpst` tool:

```console
docker run --rm -v ssh:/ssh -it alpine:edge /bin/sh -c "apk --update --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing add runit && chpst -e /ssh/env /usr/bin/env | grep SSH_AUTH_SOCK"

SSH_AUTH_SOCK=/ssh/auth/sock
```

## Examples

### List Keys

```console
docker run --rm -it -v ssh:/ssh -e SSH_AUTH_SOCK=/ssh/auth/sock ubuntu /bin/bash -c "apt-get update && apt-get install -y openssh-client && ssh-add -l"
```

## Notes

- this container provides `ssh-agent` support; other common `ssh` functionality (including `known_hosts` management) is out of scope

## Compatibility

This approach is tested with:

- OSX / Virtualbox / docker-machine
- OSX / docker for mac
