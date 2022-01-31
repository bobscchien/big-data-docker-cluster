#!/bin/bash

####################################################################
# For the very first time, set $1 = init to initialize the cluster.
# To restart the cluster, do not set any argument to this script.
####################################################################

### Setup

cd bin

bash downloader.sh
bash configurator.sh
bash network-builder.sh
bash yml-builder.sh $1

cd ..

### Start cluster service on docker compose

docker-compose build --force-rm --no-cache
docker-compose up -d
