#!/bin/sh

# First argument is path to SSH key
key=$1

if [ -f "$key" ]; then
    chmod 600 "$key"
    docker run --rm -v ssh-agent-data:/ssh-agent-data -v ./ssh:/ssh:ro -it ssh-agent ssh-add "$key"
else
    echo "No private key found on the local host. Exiting."
fi
