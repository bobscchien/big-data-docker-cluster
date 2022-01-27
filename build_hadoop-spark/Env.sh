# Path
export JAVA_HOME=/usr/local/openjdk-8
export PROJECT_PROGRAM=/usr/local

# Set Hadoop
export HADOOP_HOME=$PROJECT_PROGRAM/hadoop
export YARN_HOME=$HADOOP_HOME
export HADOOP_YARN_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_INSTALL=$HADOOP_HOME
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export HADOOP_CONFIG_HOME=$HADOOP_HOME/etc/hadoop
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

# Set Hadoop (others)
export HADOOP_OPTS="$HADOOP_OPTS -Djava.library.pathdd=$HADOOP_HOME/lib/native"
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export HADOOP_CLASSPATH=$JAVA_HOME/lib/tools.jar

# Set HBase
export HBASE_HOME=$PROJECT_PROGRAM/hbase
export PATH=$PATH:$HBASE_HOME/bin

# Set Spark
export SPARK_HOME=$PROJECT_PROGRAM/spark
export PATH=$PATH:$SPARK_HOME/bin

# Set Zookeeper
export ZOOKEEPER_HOME=$PROJECT_PROGRAM/zookeeper
export PATH=$PATH:$ZOOKEEPER_HOME/bin

# Set Kafka
export kafka_HOME=$PROJECT_PROGRAM/kafka
export PATH=$PATH:$kafka_HOME/bin

# User
export HDFS_NAMENODE_USER=hadoop
export HDFS_DATANODE_USER=hadoop
export HDFS_JOURNALNODE_USER=hadoop
export HDFS_ZKFC_USER=hadoop
export YARN_RESOURCEMANAGER_USER=hadoop
export YARN_NODEMANAGER_USER=hadoop
