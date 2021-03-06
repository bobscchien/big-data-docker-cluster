#!/bin/bash

####################################################################
# Stop the services based on the following order, and then remove 
# all the containers (the data and logs will not be removed)
####################################################################

source ./conf.ini
source ./config/env.sh

for i in $(seq 1 $KAFKA_NUM);
do
    docker exec -it $KAFKA_NAME$i $KAFKA_HOME/bin/kafka-server-stop.sh
done;

docker exec -it ${NAMENODE_NAME}1 $HADOOP_HOME/bin/mapred --daemon stop historyserver
docker exec -it ${NAMENODE_NAME}1 $HADOOP_HOME/sbin/stop-yarn.sh 
docker exec -it ${NAMENODE_NAME}1 $HADOOP_HOME/sbin/stop-dfs.sh

for i in $(seq 1 $ZOOKEEPER_NUM);
do
    docker exec -it $ZOOKEEPER_NAME$i $ZOOKEEPER_HOME/bin/zkServer.sh stop
done;

docker-compose down
