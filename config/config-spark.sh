#!/bin/bash

source ../conf.ini
source ./env.sh

### Setup environment variables

spark_path=$PROJECT_DATA/spark

### Setup configuration

cd spark

cp -r ../hadoop/* .
cp spark-defaults.conf.template spark-defaults.conf  
cp spark-env.sh.template spark-env.sh

# Configure spark-env.sh

cat <<EOF >> spark-env.sh

JAVA_HOME=$JAVA_HOME

SPARK_CONF_DIR=$SPARK_HOME/conf
YARN_CONF_DIR=$HADOOP_HOME/etc/hadoop
HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop

SPARK_EXECUTOR_CORES=$SPARK_EXECUTOR_CORES
SPARK_EXECUTOR_MEMORY=$SPARK_EXECUTOR_MEMORY
SPARK_DRIVER_MEMORY=$SPARK_DRIVER_MEMORY

#PYSPARK_PYTHON=

EOF

cd ..

########################################## Reference ##########################################

#https://spark-nctu.gitbook.io/spark/spark-jing-an/spark-ping-tai-de-an
