#!/bin/bash

source ../conf.ini

image_name=$USER_DOCKER/apache-openjdk

docker rmi $image_name
docker build -t $image_name --build-arg PROJECT_PROGRAM=$PROJECT_PROGRAM \
                            --build-arg PROJECT_CODE=$PROJECT_CODE \
                            --build-arg PROJECT_DATA=$PROJECT_DATA \
                            -f ./Dockerfile ./

#https://hub.docker.com/_/openjdk?tab=description&page=1&ordering=last_updated
#https://www.cnblogs.com/xiaochina/p/10480774.html
