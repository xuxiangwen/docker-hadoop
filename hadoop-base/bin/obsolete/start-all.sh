source ~/cluster-install/config.`hostname`
start-dfs.sh
start-yarn.sh

$spark_home/sbin/start-all.sh
pdsh -R ssh -w $user@$zookeeper_servers $zookeeper_home/bin/zkServer.sh start
pdsh -R ssh -w $user@$zookeeper_servers $zookeeper_home/bin/zkServer.sh status
pdsh -R ssh -w $user@$kafka_servers $kafka_home/bin/kafka-server-start.sh $kafka_home/config/server.properties &
