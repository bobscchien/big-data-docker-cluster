#!/bin/bash

source ../conf.ini
source ./env.sh

### Setup environment variables

hadoop_path=$PROJECT_DATA/hadoop

for idx in $(seq 1 $ZOOKEEPER_NUM);
do
    ZOOKEEPER_CONNECT=${ZOOKEEPER_CONNECT}${ZOOKEEPER_NAME}${idx}:2181,
done
ZOOKEEPER_CONNECT=${ZOOKEEPER_CONNECT::-1}

for idx in $(seq 1 $DATANODE_NUM);
do
    JOURNALNODES=${JOURNALNODES}${JOURNAL_NAME}${idx}:8485';'
done
JOURNALNODES=${JOURNALNODES::-1}

### Setup configuration

cd hadoop

files="core-site.xml hdfs-site.xml yarn-site.xml mapred-site.xml"
for file in $files;
do 
    sed -i 's/<configuration>//g' $file
    sed -i 's/<\/configuration>//g' $file
done;



# Configure hadoop-env.sh

cat <<EOF >> hadoop-env.sh

export HDFS_NAMENODE_USER=$HDFS_NAMENODE_USER
export HDFS_DATANODE_USER=$HDFS_DATANODE_USER
export HDFS_JOURNALNODE_USER=$HDFS_JOURNALNODE_USER
export HDFS_ZKFC_USER=$HDFS_ZKFC_USER
export YARN_RESOURCEMANAGER_USER=$YARN_RESOURCEMANAGER_USER
export YARN_NODEMANAGER_USER=$YARN_NODEMANAGER_USER

export HADOOP_HOME=$HADOOP_HOME

#export HADOOP_OPTS=-Djava.net.preferIPv4Stack=true
#export HADOOP_OPTS="$HADOOP_OPTS -Djava.library.path=$HADOOP_HOME/lib/native"
export HADOOP_OPTS="-Djava.library.path=\$HADOOP_HOME/lib/native"
export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop
export HADOOP_CONFIG_HOME=\$HADOOP_HOME/etc/hadoop
export HADOOP_LOG_DIR=$hadoop_path/logs
export JAVA_HOME=$JAVA_HOME

EOF
echo "export JAVA_HOME=$JAVA_HOME" >> mapred-env.sh
echo "export JAVA_HOME=$JAVA_HOME" >> yarn-env.sh



# Configure worker / datanode

>  workers
for idx in $(seq 1 $DATANODE_NUM);
do
    echo ${DATANODE_NAME}${idx} >> workers
done



# Configure namenode cluster

for idx in $(seq 1 $NAMENODE_NUM);
do
    nn_cluster=${nn_cluster}nn${idx},
done
nn_cluster=${nn_cluster::-1}



# Configure yarn cluster

for idx in $(seq 1 $YARN_NUM);
do
    rm_cluster=${rm_cluster}rm${idx},
done
rm_cluster=${rm_cluster::-1}



# Configure core-site.xml

file=core-site.xml
cat <<EOF >> $file

<configuration>
<!-- 組裝多個Namenode為一個cluster -->
        <property>
                <name>fs.defaultFS</name>
                <value>hdfs://$CLUSTER_HDFS</value>
        </property>
<!-- 設定hadoop運行產生文件目錄 -->
        <property>
                <name>hadoop.tmp.dir</name>
                <value>$hadoop_path/tmp</value>
                <description>A base for other temporary directories.</description>
        </property>
<!-- 指定zookeeper連線位置以執行HA -->
        <property>
                <name>ha.zookeeper.quorum</name>
                <value>$ZOOKEEPER_CONNECT</value>
        </property>
 <!--修改core-site.xml中的ipc参数防止出现连接服务ConnectException-->
        <property>
                <name>ipc.client.connect.max.retries</name>
                <value>50</value>
        </property>
</configuration>

EOF



# Configure hdfs-site.xml

file=hdfs-site.xml
cat <<EOF >> $file

<configuration>
<!-- 完全分佈式集群名稱 -->
        <property>
                <name>dfs.nameservices</name>
                <value>$CLUSTER_HDFS</value>
        </property>
<!-- 完全分佈式集群節點 -->
        <property>
		<name>dfs.ha.namenodes.$CLUSTER_HDFS</name>
		<value>$nn_cluster</value>
        </property>
<!-- Namenode數據存儲目錄 -->
        <property>
                <name>dfs.namenode.name.dir</name>
                <value>file:$hadoop_path/tmp/name</value>
        </property>
<!-- Datanode數據存儲目錄 -->
        <property>
                <name>dfs.datanode.data.dir</name>
                <value>file:$hadoop_path/tmp/data</value>
        </property>
<!-- Journalnode數據存儲目錄 -->
        <property>
                <name>dfs.journalnode.edits.dir</name>
                <value>$hadoop_path/tmp/journal</value>
        </property>
<!-- Namenode原數據在Journalnode的存放位置 -->
        <property>
                <name>dfs.namenode.shared.edits.dir</name>
                <value>qjournal://$JOURNALNODES/$CLUSTER_HDFS</value>
        </property>
<!-- HA：Client用於確認Active的Namenode的訪問代理 -->
        <property>
                <name>dfs.client.failover.proxy.provider.$CLUSTER_HDFS</name>
                <value>org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider</value>
        </property>
<!-- HA：啟動故障自動轉移 -->
        <property>
                <name>dfs.ha.automatic-failover.enabled</name>
                <value>true</value>
        </property>
<!-- 隔離配置機制：同一時間只有一台Namenode對外響應 -->
        <property>
                <name>dfs.ha.fencing.methods</name>
                <value>sshfence</value>
        </property>
<!-- 隔離配置機制：使用ssh密鑰登入 -->
        <property>
                <name>dfs.ha.fencing.ssh.private-key-files</name>
                <value>~/.ssh/id_rsa</value>
        </property>
<!-- 依照Datanode數量調整 -->
        <property>
                <name>dfs.replication</name>
                <value>$DATANODE_NUM</value>
        </property>
EOF

for n in $(seq 1 $NAMENODE_NUM);
do 
cat <<EOF >> $file
<!-- 完全分佈式集群節點RPC通信地址 -->
        <property>
                <name>dfs.namenode.rpc-address.$CLUSTER_HDFS.nn$n</name>
                <value>${NAMENODE_NAME}${n}:8020</value>
        </property>
<!-- 完全分佈式集群節點HTTP通信地址 -->
        <property>
                <name>dfs.namenode.http-address.$CLUSTER_HDFS.nn$n</name>
                <value>${NAMENODE_NAME}${n}:9870</value>
        </property>
EOF
done;
echo '</configuration>' >> $file



# Configure yarn-site.xml

file=yarn-site.xml
cat <<EOF >> $file

<configuration>
        <property>
                <name>yarn.nodemanager.aux-services</name>
                <value>mapreduce_shuffle</value>
        </property>
<!-- 啟用resource manager ha -->
        <property>
                <name>yarn.resourcemanager.ha.enabled</name>
                <value>true</value>
        </property>
<!-- 指定RM連線地址 -->
        <property>
                <name>yarn.resourcemanager.cluster-id</name>
                <value>$CLUSTER_YARN</value>
        </property>
<!-- 指定RM邏輯列表 -->
        <property>
                <name>yarn.resourcemanager.ha.rm-ids</name>
                <value>$rm_cluster</value>
        </property>
<!-- Zookeeper 集群位置 -->
        <property>
                <name>yarn.resourcemanager.zk-address</name>
                <value>$ZOOKEEPER_CONNECT</value>
        </property>
<!-- 啟動自動恢復 -->
        <property>
                <name>yarn.resourcemanager.recovery.enabled</name>
                <value>true</value>
        </property>
<!-- 指定RM的狀態訊息存儲在zookeeper集群中 -->
        <property>
                <name>yarn.resourcemanager.store.class</name>
                <value>org.apache.hadoop.yarn.server.resourcemanager.recovery.ZKRMStateStore</value>
        </property>
<!-- 環境變數繼承 -->
        <property>
                <name>yarn.nodemanager.env-whitelist</name>
                <value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PREPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_MAPRED_HOME</value>
        </property>
EOF

for n in $(seq 1 $YARN_NUM);
do 
cat <<EOF >> $file
<!-- RM 配置設定 -->
        <property>
                <name>yarn.resourcemanager.hostname.rm$n</name>
                <value>${YARN_NAME}${n}</value>
        </property>
        <property>
                <name>yarn.resourcemanager.scheduler.address.rm$n</name>
                <value>${YARN_NAME}${n}:8030</value>
        </property>
        <property>
                <name>yarn.resourcemanager.resource-tracker.address.rm$n</name>
                <value>${YARN_NAME}${n}:8031</value>
        </property>
        <property>
                <name>yarn.resourcemanager.address.rm$n</name>
                <value>${YARN_NAME}${n}:8032</value>
        </property>
        <property>
                <name>yarn.resourcemanager.admin.address.rm$n</name>
                <value>${YARN_NAME}${n}:8033</value>
        </property>
        <property>
                <name>yarn.resourcemanager.webapp.address.rm$n</name>
                <value>${YARN_NAME}${n}:8088</value>
        </property>
EOF
done;
echo '</configuration>' >> $file



# Configure mapred-site.xml

file=mapred-site.xml
cat <<EOF >> $file

<configuration>
	<property>
		<name>mapreduce.framework.name</name>
		<value>yarn</value>
  	</property>
  	<property>
    		<name>mapreduce.jobhistory.address</name>
    		<value>${NAMENODE_NAME}1:10020</value>
  	</property>
  	<property>
    		<name>mapreduce.jobhistory.webapp.address</name>
		<value>${NAMENODE_NAME}1:19888</value>
  	</property>
<!-- 讓datanode可以被namenode追蹤到 -->
        <property>
                <name>mapred.job.tracker</name>
                <value>${NAMENODE_NAME}1:9001</value>
        </property>
</configuration>

EOF

cd ..

########################################## Reference ##########################################

# End-to-end Setup
#https://hackmd.io/@JeffWen/hadoop

# Journal Timeout
#https://community.cloudera.com/t5/Support-Questions/What-is-the-HDFS-NameNode-configuration-for-the/td-p/167221

# Offical Documentation
#https://hadoop.apache.org/docs/r3.1.1/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml
#https://ambari.apache.org/1.2.5/installing-hadoop-using-ambari/content/reference_chap2.html
