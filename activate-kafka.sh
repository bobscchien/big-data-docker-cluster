#!/bin/bash

#############################################################
# This script can only be used in the containers
#############################################################

source /etc/bash.bashrc
source /code/conf.ini

### Update configuration

su - root << EOF
cp $PROJECT_CODE/config/hosts /etc/
EOF

cp -r $PROJECT_CODE/config/kafka/* $PROJECT_PROGRAM/kafka/config/

### Specify ID of Broker

while :; do
    case $1 in
        --id) broker_id=$2
        ;;
        *) break
    esac
    shift
done

cat <<EOF >> $PROJECT_PROGRAM/kafka/config/server.properties

broker.id=$broker_id
listeners=PLAINTEXT://`hostname`:9092
advertised.listeners=PLAINTEXT://`hostname`:9092

EOF

### Start Apache Kafka

echo 'Start Apache Kafka...'
kafka-server-start.sh -daemon $PROJECT_PROGRAM/kafka/config/server.properties

tail -f /dev/null

######################### Reference #########################

#https://www.cnblogs.com/struggle-1216/p/12495205.html
#https://kafka.apache.org/documentation/#brokerconfigs
#https://oranwind.org/-big-data-apache-kafka-an-zhuang-jiao-xue/
