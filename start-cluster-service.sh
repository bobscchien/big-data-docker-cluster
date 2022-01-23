#!/bin/bash

case "$1" in
    --init)
        INIT=init
    ;;    
esac

### Setup

cd bin

bash downloader.sh
bash configurator.sh
bash network-builder.sh
bash yml-builder.sh $INIT

cd ..

### Start cluster service on docker compose

docker-compose build --force-rm --no-cache
docker-compose up -d
