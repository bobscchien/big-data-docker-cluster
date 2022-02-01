#!/bin/bash

source ../conf.ini

### Setup configuration

cd zookeeper
cp zoo_sample.cfg zoo.cfg

cat <<EOF > zoo.cfg

dataDir=$PROJECT_DATA/zookeeper/data
dataLogDir=$PROJECT_DATA/zookeeper/logs
clientPort=2181
tickTime=2000
initLimit=10
syncLimit=5
maxClientCnxns=4096
autopurge.snapRetainCount=512
autopurge.purgeInterval=1

admin.serverPort=8010

EOF

# Configure clusters			# 依照集群大小填寫對應數目的IP位置(2888:集群內通訊使用;3888:選舉leader使用)

for idx in $(seq 1 $ZOOKEEPER_NUM);
do
    echo "server.$idx=${ZOOKEEPER_NAME}${idx}:2888:3888;2181" >> zoo.cfg;
done;

cd ..

########################################## Reference ##########################################

#dataDir			# 定義zookeeper保存數據位置
#dataLogDir
#clientPort			# 使用者和Zookeeper相連的port
#tickTime                   # 基本事件單元，以毫秒為單位。它用來控制心跳和超時，預設情況下最小的會話超時時間為兩倍的 tickTime
#initLimit                  # 初始化連線時最長能忍受多少個心跳時間間隔數
#syncLimit                  # 這個配置項標識 Leader 與 Follower 之間傳送訊息，請求和應答時間長度
#maxClientCnxns             # Client最大連線個數
#autopurge.snapRetainCount  # 設置zookeeper保存多少次Client數據
#autopurge.purgeInterval	# 設置zookeeper間隔幾個小時清理一次Client保存數據

# Version Issue
#https://blog.csdn.net/Java_HuiLong/article/details/110383191
