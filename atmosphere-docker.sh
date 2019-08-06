#!/bin/bash
dockerhost=$(ip addr show docker0 | grep -Po 'inet \K[\d.]+') docker-compose $@
