#!/bin/bash

source ../conf.ini

file_spark=spark-$SPARK_VER-bin-hadoop$SPARK_HADOOP_VER-scala$SCALA_VER
file_hadoop=hadoop-$HADOOP_VER
image_source=$USER_DOCKER/apache-openjdk
image_target=$USER_DOCKER/apache-hadoop-spark:$HADOOP_VER-$SPARK_VER

# Copy program file from pacakge directory
cp -r $DIR_PACKAGE/$file_hadoop .
cp -r $DIR_PACKAGE/$file_spark .

# Remove and recreate docker image
docker rmi $image_target
docker build -t $image_target --build-arg FILE_SPARK=$file_spark \
                              --build-arg FILE_HADOOP=$file_hadoop \
                              --build-arg PROJECT_PROGRAM=$PROJECT_PROGRAM \
                              --build-arg PROJECT_DATA=$PROJECT_DATA \
                              -f ./Dockerfile ./

# Remove program file
rm -r $file_hadoop $file_spark
