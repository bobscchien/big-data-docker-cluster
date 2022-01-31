#!/bin/bash

#############################################################
# This script can only be used in the containers
#############################################################

source /code/conf.ini
source /code/config/env.sh

### Update configuration

cp -r $PROJECT_CODE/config/zookeeper/* $ZOOKEEPER_HOME/conf/

### Specify ID of Zookeeper

dataDir=$PROJECT_DATA/zookeeper
while :; do
    case $1 in
        --id) zookeeper_id=$2
        ;;
        *) break
    esac
    shift
done

su - root << EOF

mkdir -p $dataDir/data
echo $zookeeper_id > $dataDir/data/myid

chown -R zookeeper:zookeeper $PROJECT_DATA/zookeeper

cat $PROJECT_CODE/config/hosts > /etc/hosts

EOF

zkServer.sh start
zkServer.sh status

tail -f /dev/null
