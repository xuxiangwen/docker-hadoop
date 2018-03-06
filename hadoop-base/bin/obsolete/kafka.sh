source ~/cluster-install/config.`hostname`

#70 setup-zookeeper.sh
pdsh -R ssh -w $user@$zookeeper_servers $targetpath/setup-zookeeper.sh

pdsh -R ssh -w $user@$zookeeper_servers $zookeeper_home/bin/zkServer.sh start
pdsh -R ssh -w $user@$zookeeper_servers $zookeeper_home/bin/zkServer.sh status
pdsh -R ssh -w $user@$zookeeper_servers $zookeeper_home/bin/zkServer.sh stop


#75 setup kafka http://www.cnblogs.com/oftenlin/p/4047504.html
pdsh -R ssh -w $user@$kafka_servers $targetpath/setup-kafka.sh

pdsh -R ssh -w $user@$kafka_servers $kafka_home/bin/kafka-server-start.sh $kafka_home/config/server.properties &
pdsh -R ssh -w $user@$kafka_servers $kafka_home/bin/kafka-server-stop.sh $kafka_home/config/server.properties



#create topic
source ~/cluster-install/config.`hostname`
$kafka_home/bin/kafka-topics.sh --zookeeper $zookeeper_connect --topic test --replication-factor 2 --partitions 3 --create
$kafka_home/bin/kafka-topics.sh --describe --zookeeper $zookeeper_connect --topic test 
#list topic
$kafka_home/bin/kafka-topics.sh --list --zookeeper $zookeeper_connect
#generate message
$kafka_home/bin/kafka-console-producer.sh --broker-list $kafka_connect --topic test
#auto generate 200 message
$kafka_home/bin/kafka-verifiable-producer.sh --broker-list $kafka_connect --topic test --max-messages 200 
#get message 
$kafka_home/bin/kafka-console-consumer.sh --zookeeper $zookeeper_connect --from-beginning --topic test 

#Consumer Group Inspection
$kafka_home/bin/kafka-consumer-groups.sh –-new-consumer --describe --group xujian1 –-bootstrap-server $kafka_connect --zookeeper $zookeeper_connect
#check the offset of the group
$kafka_home/bin/kafka-run-class.sh kafka.tools.ConsumerOffsetChecker --zookeeper $zookeeper_connect --group xujian1
#Export Zookeeper Offsets
$kafka_home/bin/kafka-run-class.sh kafka.tools.ExportZkOffsets --zkconnect $zookeeper_connect --group xujian1 --output-file xujian1-zk-offset.txt

#read the offsets topic 
source ~/cluster-install/config.`hostname`
echo "exclude.internal.topics=false" > /tmp/consumer.config
$kafka_home/bin/kafka-console-consumer.sh --zookeeper $zookeeper_connect --topic __consumer_offsets \
 --formatter "kafka.coordinator.GroupMetadataManager\$OffsetsMessageFormatter" \
 --consumer.config /tmp/consumer.config \
 --from-beginning
 
source ~/cluster-install/config.`hostname`
$kafka_home/bin/kafka-simple-consumer-shell.sh --broker-list $kafka_connect --topic __consumer_offsets \
 --formatter "kafka.coordinator.GroupMetadataManager\$OffsetsMessageFormatter" \
 --partition 0

#查看topic每个分区的最新offset
$kafka_home/bin/kafka-run-class.sh kafka.tools.GetOffsetShell --broker-list $kafka_connect --topic sequence_number --time  -1
$kafka_home/bin/kafka-run-class.sh kafka.tools.GetOffsetShell --broker-list $kafka_connect --topic sequence_number_consumer --time  -1

