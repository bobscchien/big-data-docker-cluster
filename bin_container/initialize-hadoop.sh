#!/bin/bash

#############################################################
# This script can only be used in the containers
#############################################################

source /code/conf.ini
source /code/config/env.sh

### Update configuration

cp -r $PROJECT_CODE/config/hadoop/* $HADOOP_HOME/etc/hadoop/
cp -r $PROJECT_CODE/config/hadoop/* $SPARK_HOME/conf

su - root << EOF

chown -R hadoop:hadoop $PROJECT_DATA/hadoop 

cat $PROJECT_CODE/config/hosts > /etc/hosts

EOF

name=`hostname`

case $name in 

    ${NAMENODE_NAME}1 )

    if [ "$1" == "init" ];then
        echo "Initialize Master Namenode"
        yes | hdfs namenode -format && hdfs --daemon start namenode

        # Wait for other namenodes to be started and assigned as standby 
        sleep 60

        echo "Shut down and wait for restart"
        stop-dfs.sh

        echo "Format Zookeeper Failure Controller"
        yes | hdfs zkfc -formatZK
    else
        sleep 30
    fi

    # ----------------------------------------------------------------- #

    echo 'Start Apach Hadoop HDFS...'

    # Start HDFS
    start-dfs.sh
    hdfs haadmin -getServiceState nn1
    hdfs haadmin -getServiceState nn2

    echo 'Start Apach Hadoop Yarn...'
    start-yarn.sh
    yarn rmadmin -getServiceState rm1
    yarn rmadmin -getServiceState rm2

    echo 'Start Apach Hadoop MapReduce History Server...'
    mapred --daemon start historyserver
    ;;

    "${NAMENODE_NAME}"[2-9] )
    if [ "$1" == "init" ];then
        echo "Initialize Standby Namenodes"
        yes | hdfs namenode -bootstrapStandby && hdfs --daemon start namenode
    fi
    ;;

    "${DATANODE_NAME}"* )

    if [ "$1" == "init" ];then
        echo "Initialize Journalnodes"
        hdfs --daemon start journalnode
    fi
    ;;
esac

tail -f /dev/null

######################### Reference #########################

# Start order - main
# https://hackmd.io/@JeffWen/hadoop#Spark%E5%8F%8AJupyter%E6%87%89%E7%94%A8%E7%A8%8B%E5%BC%8F%E5%AE%89%E8%A3%9D

# Start order - other
# https://docs.cloudera.com/HDPDocuments/HDP2/HDP-2.4.2/bk_HDP_Reference_Guide/content/starting_hdp_services.html
# https://hadoop.apache.org/docs/r3.1.1/hadoop-project-dist/hadoop-common/ClusterSetup.html

# zkfc format
# https://community.cloudera.com/t5/Support-Questions/namenode-HA-and-hdfs-zkfc-formatZK-force/td-p/302766
