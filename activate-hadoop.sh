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

cp -r $PROJECT_CODE/config/hadoop/* $PROJECT_PROGRAM/hadoop/etc/hadoop/

hadoop conftest

### Start the Apach Hadoop

case $1 in
    nna|namenode_active)
	echo 'Active Namenode is ready.'

	### Initialization for the first time

	if [ "$2" = "init" ];then

		# Start Journalnodes
		for i in $(seq 1 $DATANODE_NUM);
		do
			ssh $DATANODE_NAME$i "hdfs --daemon start journalnode"
		done;

		hdfs namenode -initializeSharedEdits
	
		# Namemode format
		yes | hdfs namenode -format

		# Start Namenodes
		hdfs --daemon start namenode
		for i in $(seq 2 $NAMENODE_NUM);
		do
			# copy the meta data
			ssh $NAMENODE_NAME$i "yes | hdfs namenode -bootstrapStandby && hdfs --daemon start namenode"
		done;

		# Shutdown
		stop-dfs.sh
	fi

	### Start the Cluster

	# zkfc format
	yes | hdfs zkfc -formatZK

	# Start HDFS
	start-dfs.sh
	hdfs haadmin -transitionToActive nn1
	hdfs haadmin -getServiceState nn1
	hdfs haadmin -getServiceState nn2

	# Start YARN
	ssh ${YARN_NAME}1 "start-yarn.sh"
	ssh ${YARN_NAME}1 "yarn rmadmin -getServiceState rm1;yarn rmadmin -getServiceState rm2"
	mapred --daemon start historyserver
	;;

    nns|namenode_standby)
	echo 'Standby Namenode is ready.'
    ;;

    rm1|yarn_active)
	echo 'Active Resource manager is ready.'
    ;;

    rm2|yarn_standby)
	echo 'Standby Resource manager is ready.'
    ;;

    djn|datanode)
	echo 'Journal / Data Node is ready.'
    ;;
	
    *)
	echo 'NameNode Active (nna) / NameNode Standby (nns) / Yarn Active (rm1) / Yarn Standby (rm2) / DataJournalNode (djn)'
    ;;
esac

tail -f /dev/null

########################################## Reference ##########################################

# Start order - main
# https://hackmd.io/@JeffWen/hadoop#Spark%E5%8F%8AJupyter%E6%87%89%E7%94%A8%E7%A8%8B%E5%BC%8F%E5%AE%89%E8%A3%9D

# Start order - other
# https://docs.cloudera.com/HDPDocuments/HDP2/HDP-2.4.2/bk_HDP_Reference_Guide/content/starting_hdp_services.html
# https://hadoop.apache.org/docs/r3.1.1/hadoop-project-dist/hadoop-common/ClusterSetup.html

# zkfc format
# https://community.cloudera.com/t5/Support-Questions/namenode-HA-and-hdfs-zkfc-formatZK-force/td-p/302766
