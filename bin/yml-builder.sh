#!/bin/bash

#############################################################
# Automatically create the docker-compose.yml file
#############################################################

source ../conf.ini

file='../docker-compose.yml'

# ========================================================= #

cat <<EOF > $file
version: "3.7"

services:
EOF

# =================== Hadoop - Namenode =================== #

cat <<EOF >> $file

### Hadoop - Namenode

  ${NAMENODE_NAME}1:
    container_name: ${NAMENODE_NAME}1
    hostname: ${NAMENODE_NAME}1
    image: $USER_DOCKER/apache-hadoop-spark:$HADOOP_VER-$SPARK_VER
    user: hadoop
    volumes:
      - .:$PROJECT_CODE:ro
      - ${DIR_DATA_TOP}1/$DIR_DATA_APP/${NAMENODE_NAME}1:$PROJECT_DATA/hadoop:rw
    networks:
      custom-net:
        ipv4_address: ${NAMENODE_NET}.1
    ports:
      - 18020:8020
      - 18088:8088
      - 19870:9870
      - 19888:19888
    deploy:
      resources:
        limits:
          cpus: $NAMENODE_CPU
          memory: $NAMENODE_MEM
    restart: unless-stopped
    command: $PROJECT_CODE/bin_container/initialize-hadoop.sh $1
    depends_on:
EOF

for n in $(seq 1 $ZOOKEEPER_NUM);
do 
cat <<EOF >> $file
      - ${ZOOKEEPER_NAME}$n
EOF
done;

for n in $(seq 1 $DATANODE_NUM);
do 
cat <<EOF >> $file
      - ${DATANODE_NAME}$n
EOF
done;

for n in $(seq 2 $NAMENODE_NUM);
do
cat <<EOF >> $file
  ${NAMENODE_NAME}${n}:
    container_name: ${NAMENODE_NAME}${n}
    hostname: ${NAMENODE_NAME}${n}
    image: $USER_DOCKER/apache-hadoop-spark:$HADOOP_VER-$SPARK_VER
    user: hadoop
    volumes:
      - .:$PROJECT_CODE:ro
      - ${DIR_DATA_TOP}${n}/$DIR_DATA_APP/${NAMENODE_NAME}2:$PROJECT_DATA/hadoop:rw
    networks: 
      custom-net:
        ipv4_address: ${NAMENODE_NET}.${n}
    ports:
      - 28020:8020
      - 28088:8088
      - 29870:9870
      - 29888:19888
    deploy:
      resources:
        limits:
          cpus: $NAMENODE_CPU
          memory: $NAMENODE_MEM
    restart: unless-stopped
    command: $PROJECT_CODE/bin_container/initialize-hadoop.sh $1
    depends_on:
      - ${NAMENODE_NAME}1
EOF
done;

# =================== Hadoop - Datanode =================== #

cat <<EOF >> $file

### Hadoop - Datanode / Journalnode 

EOF

for n in $(seq 1 $DATANODE_NUM);
do 
cat <<EOF >> $file
  ${DATANODE_NAME}${n}:
    container_name: ${DATANODE_NAME}${n}
    hostname: ${DATANODE_NAME}${n}
    image: $USER_DOCKER/apache-hadoop-spark:$HADOOP_VER-$SPARK_VER
    user: hadoop
    volumes:
      - .:$PROJECT_CODE:ro
      - ${DIR_DATA_TOP}${n}/$DIR_DATA_APP/${DATANODE_NAME}${n}:$PROJECT_DATA/hadoop:rw
    networks:
      custom-net:
        ipv4_address: ${DATANODE_NET}.${n}
    deploy:
      resources:
        limits:
          cpus: $DATANODE_CPU
          memory: $DATANODE_MEM
    restart: unless-stopped
    command: $PROJECT_CODE/bin_container/initialize-hadoop.sh $1
EOF
done;

# ======================= Zookeeper ======================= #

cat <<EOF >> $file

### Zookeeper

EOF

for n in $(seq 1 $ZOOKEEPER_NUM);
do 
cat <<EOF >> $file
  ${ZOOKEEPER_NAME}${n}:
    container_name: ${ZOOKEEPER_NAME}${n}
    hostname: ${ZOOKEEPER_NAME}${n}
    image: $USER_DOCKER/apache-zookeeper:$ZOOKEEPER_VER
    user: zookeeper
    volumes:
      - .:$PROJECT_CODE:ro
      - ${DIR_DATA_TOP}${n}/$DIR_DATA_APP/${ZOOKEEPER_NAME}${n}:$PROJECT_DATA/zookeeper:rw
    networks:
      custom-net:
        ipv4_address: ${ZOOKEEPER_NET}.${n}
    ports:
      - ${n}8010:8010
      - ${n}2181:2181
    deploy:
      resources:
        limits:
          cpus: $ZOOKEEPER_CPU
          memory: $ZOOKEEPER_MEM
    restart: unless-stopped
    command: $PROJECT_CODE/bin_container/initialize-zookeeper.sh --id ${n}
EOF
done;

# ========================= Kafka ========================= #

cat <<EOF >> $file

### Kafka

EOF

for n in $(seq 1 $KAFKA_NUM);
do 
cat <<EOF >> $file
  ${KAFKA_NAME}${n}:
    container_name: ${KAFKA_NAME}${n}
    hostname: ${KAFKA_NAME}${n}
    image: $USER_DOCKER/apache-kafka:$KAFKA_VER
    user: kafka
    volumes:
      - .:$PROJECT_CODE:ro
      - ${DIR_DATA_TOP}${n}/$DIR_DATA_APP/${KAFKA_NAME}${n}:$PROJECT_DATA/kafka:rw
    networks:
      custom-net:
        ipv4_address: ${KAFKA_NET}.${n}
    ports:
      - ${n}9092:9092
    deploy:
      resources:
        limits:
          cpus: $KAFKA_CPU
          memory: $KAFKA_MEM
    restart: unless-stopped
    command: $PROJECT_CODE/bin_container/initialize-kafka.sh --id ${n}
    depends_on:
EOF

for z in $(seq 1 $ZOOKEEPER_NUM);
do
cat <<EOF >> $file
      - ${ZOOKEEPER_NAME}${z}
EOF
done;
done;

# ========================================================= #

cat <<EOF >> $file

### Network & Volume

networks:
  custom-net:
    external:
      name: $CUSTOM_NET
EOF
