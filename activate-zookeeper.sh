#!/bin/bash

#############################################################
# This script can only be used in the containers
#############################################################

source ~/.bashrc
source /code/conf.ini

### Update configuration

cp $PROJECT_CODE/config/hosts /etc/
cp -r $PROJECT_CODE/config/zookeeper/* $PROJECT_PROGRAM/zookeeper/conf/

### Specify ID of Zookeeper

dataDir=$PROJECT_DATA/zookeeper
while :; do
    case $1 in
        --id) zookeeper_id=$2
        ;;
        --dataDir) dataDir=$2
        ;;
        *) break
    esac
    shift
done

mkdir -p $dataDir/data
echo $zookeeper_id > $dataDir/data/myid

### Start the Apache Zookeeper

echo -e '\nStart Apache Zookeeper...'
zkServer.sh start #start-foreground

echo -e '\nShow status of Apache Zookeeper:'
zkServer.sh status

tail -f /dev/null
