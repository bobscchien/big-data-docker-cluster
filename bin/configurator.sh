#!/bin/bash

#############################################################
# Setup all the configurations based on the setting in conf.ini
#############################################################

source ../conf.ini

# Build initial configurations

cp $DIR_PACKAGE/apache-zookeeper-${ZOOKEEPER_VER}-bin/conf/* ../config/zookeeper/
cp $DIR_PACKAGE/kafka_${SCALA_VER}-${KAFKA_VER}/config/* ../config/kafka/
cp -r $DIR_PACKAGE/hadoop-${HADOOP_VER}/etc/hadoop/* ../config/hadoop/
cp -r $DIR_PACKAGE/spark-${SPARK_VER}-bin-hadoop${SPARK_HADOOP_VER}-scala${SCALA_VER}/conf/* ../config/spark/

cd ../config

# Zookeeper configuration

bash config-zookeeper.sh 

# Kafka configuration

bash config-kafka.sh 

# Hadoop configuration

bash config-hadoop.sh 

# Hadoop configuration

bash config-spark.sh 

# Create host file

> hosts

for i in $(seq 1 $ZOOKEEPER_NUM);
do
    echo "$ZOOKEEPER_NET.$i ${ZOOKEEPER_NAME}${i}" >> hosts
done;

for i in $(seq 1 $KAFKA_NUM);
do
    echo "$KAFKA_NET.$i ${KAFKA_NAME}${i}" >> hosts
done;

for i in $(seq 1 $YARN_NUM);
do
    echo "$YARN_NET.$i ${YARN_NAME}${i}" >> hosts
done;

for i in $(seq 1 $NAMENODE_NUM);
do
    echo "$NAMENODE_NET.$i ${NAMENODE_NAME}${i}" >> hosts
done;

for i in $(seq 1 $DATANODE_NUM);
do
    echo "$DATANODE_NET.$i ${DATANODE_NAME}${i}" >> hosts
done;
