#!/bin/bash

#############################################################
# Download the necessary installation packages and unzip them
# based on the setting in conf.ini
#############################################################

source ../conf.ini

# Java - JDK 8



# Apache Zookeeper

filename="apache-zookeeper-${ZOOKEEPER_VER}-bin.tar.gz"
filepath=$DIR_PACKAGE/$filename

if [ ! -f "$filepath" ];then
    wget -P $DIR_PACKAGE "https://dlcdn.apache.org/zookeeper/zookeeper-${ZOOKEEPER_VER}/${filename}"
    tar xvf $filepath
fi

# Apache Kafka

filename="kafka_${SCALA_VER}-${KAFKA_VER}.tgz"
filepath=$DIR_PACKAGE/$filename

if [ ! -f "$filepath" ];then
    wget -P $DIR_PACKAGE "https://dlcdn.apache.org/kafka/${KAFKA_VER}/${filename}"
    tar xvf $filepath
fi

# Apache Hadoop

filename="hadoop-${HADOOP_VER}.tar.gz"
filepath=$DIR_PACKAGE/$filename

if [ ! -f "$filepath" ];then
    wget -P $DIR_PACKAGE "https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VER}/${filename}"
    tar xvf $filepath
fi

# Apach Spark

filename="spark-${SPARK_VER}-bin-hadoop${SPARK_HADOOP_VER}-scala${SCALA_VER}.tgz"
filepath=$DIR_PACKAGE/$filename

if [ ! -f "$filepath" ];then
    wget -P $DIR_PACKAGE "https://dlcdn.apache.org/spark/spark-${SPARK_VER}/${filename}"
    tar xvf $filepath
fi
