#!/bin/bash

source ../conf.ini

### Setup local variables

kafka_path=$PROJECT_DATA/kafka

for idx in $(seq 1 $ZOOKEEPER_NUM); 
do 
  ZOOKEEPER_CONNECT=${ZOOKEEPER_CONNECT}${ZOOKEEPER_NAME}${idx}:2181, 
done 
ZOOKEEPER_CONNECT=${ZOOKEEPER_CONNECT::-1}



### Setup configuration

cd kafka

cat <<EOF > server.properties

log.dirs=$kafka_path/kafka-logs
zookeeper.connect=$ZOOKEEPER_CONNECT
zookeeper.connection.timeout.ms=18000

auto.create.topics.enable=true			
delete.topic.enable=true 			

auto.leader.rebalance.enable=true		
leader.imbalance.per.broker.percentage=10
leader.imbalance.check.interval.seconds=300

default.replication.factor=1 
num.replica.fetchers=1
num.partitions=1 
num.io.threads=2
num.network.threads=1
num.recovery.threads.per.data.dir=1

socket.send.buffer.bytes=102400
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600

offset.metadata.max.bytes=4096
offsets.topic.replication.factor=$KAFKA_NUM
transaction.state.log.replication.factor=$KAFKA_NUM
transaction.state.log.min.isr=$KAFKA_NUM

log.flush.scheduler.interval.ms=3000
log.flush.interval.messages=10000
log.flush.interval.ms=1000
log.flush.offset.checkpoint.interval.ms=60000

log.retention.hours=168
log.retention.check.interval.ms=300000

group.initial.rebalance.delay.ms=3000

background.threads=1
queued.max.requests=500
message.max.bytes=1048588
controller.socket.timeout.ms=30000
controlled.shutdown.enable=true
controlled.shutdown.max.retries=3
controlled.shutdown.retry.backoff.ms=5000
log.segment.bytes=1073741824
log.roll.hours=168
log.cleanup.policy=delete
log.cleaner.enable=true
log.cleaner.threads=1
log.cleaner.dedupe.buffer.size=134217728
log.cleaner.io.buffer.size=524288
log.cleaner.io.buffer.load.factor=0.9
log.cleaner.backoff.ms=15000
log.cleaner.min.cleanable.ratio=0.5
log.cleaner.delete.retention.ms=86400000
log.index.size.max.bytes=10485760
log.index.interval.bytes=4096
replica.lag.time.max.ms=30000
replica.socket.timeout.ms=30000
replica.socket.receive.buffer.bytes=65536
replica.fetch.max.bytes=1048576
replica.fetch.wait.max.ms=500
replica.fetch.min.bytes=1
replica.high.watermark.checkpoint.interval.ms=5000

EOF

cd ..

########################################## Reference ##########################################

#https://prd.52liangzy.top/project-13/doc-208/
#https://kafka.apache.org/documentation/#brokerconfigs
