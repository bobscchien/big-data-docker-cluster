#!/bin/bash

source ../conf.ini

file=apache-zookeeper-$ZOOKEEPER_VER-bin
image_source=$USER_DOCKER/apache-openjdk
image_target=$USER_DOCKER/apache-zookeeper:$ZOOKEEPER_VER

# Copy program file from pacakge directory
cp -r $DIR_PACKAGE/$file .

# Remove and recreate docker image
docker rmi $image_target
docker build -t $image_target --build-arg FILE=$file \
                              --build-arg PROJECT_PROGRAM=$PROJECT_PROGRAM \
                              --build-arg PROJECT_DATA=$PROJECT_DATA \
                              -f ./Dockerfile ./

# Remove program file
rm -r $file
