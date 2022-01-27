<!--修改hdfs-site.xml连接journalnode服务ConnectException-->
        <property>
                <name>dfs.qjournal.start-segment.timeout.ms</name>
                <value>90000</value>
        </property>
        <property>
                <name>dfs.qjournal.select-input-streams.timeout.ms</name>
                <value>90000</value>
        </property>
        <property>
                <name>dfs.qjournal.write-txns.timeout.ms</name>
                <value>90000</value>
        </property>

 <!--修改core-site.xml中的ipc参数防止出现连接journalnode服务ConnectException-->
        <property>
                <name>ipc.client.connect.max.retries</name>
                <value>100</value>
        </property>
        <property>
                <name>ipc.client.connect.retry.interval</name>
                <value>90000</value>
        </property>
        <property>
                <name>ipc.client.connect.timeout</name>
                <value>90000</value>
        </property>


for n in $(seq 1 $YARN_NUM);
do 
cat <<EOF >> $file
      - ${YARN_NAME}$n
EOF
done;

# ===================== Hadoop - Yarn ===================== #

cat <<EOF >> $file

### Hadoop - Yarn / Resource Manager

EOF

for n in $(seq 1 $YARN_NUM);
do 
cat <<EOF >> $file
  ${YARN_NAME}${n}:
    container_name: ${YARN_NAME}${n}
    hostname: ${YARN_NAME}${n}
    image: $USER_DOCKER/apache-hadoop-spark:$HADOOP_VER-$SPARK_VER
    user: hadoop
    volumes:
      - .:$PROJECT_CODE:ro
    networks:
      custom-net:
        ipv4_address: ${YARN_NET}.${n}
    ports:
      - ${n}8088:8088
    deploy:
      resources:
        limits:
          cpus: $YARN_CPU
          memory: $YARN_MEM
    restart: always
    command: $PROJECT_CODE/initialize-hadoop.sh $1
EOF
done;