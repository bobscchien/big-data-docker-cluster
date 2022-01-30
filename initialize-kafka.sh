#!/bin/bash

#############################################################
# This script can only be used in the containers
#############################################################

source /code/conf.ini
source /code/config/env.sh

### Update configuration

cp -r $PROJECT_CODE/config/kafka/* $KAFKA_HOME/config/

### Specify ID of Broker

while :; do
    case $1 in
        --id) broker_id=$2
        ;;
        *) break
    esac
    shift
done

cat <<EOF >> $KAFKA_HOME/config/server.properties

broker.id=$broker_id
listeners=PLAINTEXT://`hostname`:9092
advertised.listeners=PLAINTEXT://`hostname`:9092

EOF

### Start Apache Kafka

su - root << EOF

chown -R kafka:kafka $PROJECT_DATA/kafka

cat $PROJECT_CODE/config/hosts > /etc/hosts

EOF

kafka-server-start.sh -daemon $KAFKA_HOME/config/server.properties

tail -f /dev/null

######################### Reference #########################

#https://www.cnblogs.com/struggle-1216/p/12495205.html
#https://kafka.apache.org/documentation/#brokerconfigs
#https://oranwind.org/-big-data-apache-kafka-an-zhuang-jiao-xue/
