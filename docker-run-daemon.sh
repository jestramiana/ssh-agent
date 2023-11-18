#!/bin/sh

docker run -d -v ssh-agent-data:/ssh-agent-data --name=ssh-agent ssh-agent
