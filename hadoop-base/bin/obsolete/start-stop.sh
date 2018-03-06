#Start/Stop Cluster:
source ~/cluster-install/config.`hostname`

#format namenode
pdsh -R ssh -w $user@$servers rm -rf $hadoop_data_dir
hdfs namenode -format

#Start Hadoop
start-dfs.sh
start-yarn.sh
jps
hdfs dfsadmin -report
#or
http://c1t14285.itcs.hpicorp.net:50070/dfshealth.html
http://c1t14285.itcs.hpicorp.net:8088/cluster/nodes
http://aa00:50070/dfshealth.html
http://aa00:8088/cluster/nodes


#Close Hadoop
stop-yarn.sh
stop-dfs.sh

#Testing Hadoop
source ~/cluster-install/config.`hostname`
hadoop fs -mkdir -p /input
hadoop fs -put ~/cluster-install/*.sh /input
hadoop fs -ls /input

hadoop fs -mkdir -p /output
hadoop fs -rm -r /output/wordcount
yarn jar $hadoop_home/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.5.jar wordcount /input /output/wordcount
hadoop fs -cat /output/wordcount/*

#Start Spark
$spark_home/sbin/start-all.sh
jps
http://aa01:8080
http://c1t14285.itcs.hpicorp.net:8080

#Start Spark History Server
$spark_home/sbin/start-history-server.sh
http://aa01:18080/
http://c1t14285.itcs.hpicorp.net:18080/


#Close Spark
$spark_home/sbin/stop-all.sh
jps

Stop Spark History Server
$spark_home/sbin/stop-history-server.sh

#Testing Spark
$spark_home/bin/spark-submit --master spark://$spark_master:7077 --class org.apache.spark.examples.JavaWordCount $spark_home/examples/jars/spark-examples_2.11-2.2.1.jar /input/process.sh
$spark_home/bin/spark-submit --master yarn --deploy-mode client --class org.apache.spark.examples.JavaWordCount $spark_home/examples/jars/spark-examples_2.11-2.2.1.jar /input/process.sh
$spark_home/bin/spark-submit --master yarn --deploy-mode cluster --class org.apache.spark.examples.JavaWordCount $spark_home/examples/jars/spark-examples_2.11-2.2.1.jar /input/process.sh


#Add Node to Spark Cluster
nohup spark-class org.apache.spark.deploy.worker.Worker spark://$master:7077 &

#Dynamic Adding node:
hadoop-daemon.sh start datanode
yarn-daemons.sh  start nodemanager

#stop Spark APP
spark-class org.apache.spark.deploy.Client kill spark://$master:7077 app-20150302143620-0009

#Start/Stop Zeppelin
source ~/cluster/cluster-install/config.sh
$aapath/incubator-zeppelin/bin/zeppelin-daemon.sh start
$aapath/incubator-zeppelin/bin/zeppelin-daemon.sh stop


#Flume
source ~/cluster-install/config.sh

http://www.aboutyun.com/thread-8917-1-1.html
#case 1: Avro
$flume_home/bin/flume-ng agent -c . -f /opt/mount1/seals/flume_test/avro.conf -n a1 -Dflume.root.logger=INFO,console
echo "hello world" > $flume_home/log.00
$flume_home/bin/flume-ng avro-client -c . -H c1t14289.itcs.hpicorp.net -p 4141 -F $flume_home/log.00
$flume_home/bin/flume-ng avro-client -c . -H c1t14289.itcs.hpicorp.net -p 4141 -F /

#case 2: Spool
$flume_home/bin/flume-ng agent -c . -f /opt/mount1/seals/flume_test/spool.conf -n a1 -Dflume.root.logger=INFO,console
echo "spool test1" > /opt/mount1/seals/flume_test/logs/spool_text.log

#case 3: Exec
$flume_home/bin/flume-ng agent -c . -f /opt/mount1/seals/flume_test/exec_tail.conf -n a1 -Dflume.root.logger=INFO,console
for i in {1..50};do date >> /opt/mount1/seals/flume_test/logs/log_exec_tail; sleep 1; done

#case 4:  Syslogtcp
$flume_home/bin/flume-ng agent -c . -f /opt/mount1/seals/flume_test/syslog_tcp.conf -n a1 -Dflume.root.logger=INFO,console
echo "hello idoall.org syslog" | nc localhost 5140

#case 5  JSONHandler
$flume_home/bin/flume-ng agent -c . -f /opt/mount1/seals/flume_test/post_json.conf -n a1 -Dflume.root.logger=INFO,console
curl -X POST -d '[{ "headers" :{"a" : "a1","b" : "b1"},"body" : "idoall.org_body"}]' http://localhost:8888

#case 6  hadoop sink
$flume_home/bin/flume-ng agent -c . -f /opt/mount1/seals/flume_test/hdfs_sink.conf -n a1 -Dflume.root.logger=INFO,console
echo "hello idoall.org from flume" | nc localhost 5140

$flume_home/bin/flume-ng agent -c . -f /opt/mount1/seals/flume_test/spool_hdfs_sink.conf -n a1 -Dflume.root.logger=INFO,console

rm -rf /opt/mount1/seals/flume_test/logs/*
echo "spool test25" > /opt/mount1/seals/flume_test/logs/printer.log45
echo "spool test26" > /opt/mount1/seals/flume_test/logs/printer.log46
echo "spool test27" > /opt/mount1/seals/flume_test/logs/printer.log47
echo "spool test28" > /opt/mount1/seals/flume_test/logs/printer.log48
echo "spool test29" > /opt/mount1/seals/flume_test/logs/printer.log49

vim /opt/mount1/seals/flume_test/spool_hdfs_sink.conf
cat /opt/mount1/seals/flume_test/spool_hdfs_sink.conf
hadoop fs -ls  /user/grid/flume/
hadoop fs -rm -r -f /user/grid/flume/*
hadoop fs -cat /user/grid/flume/*

rm -rf /opt/mount1/seals/flume_test/logs/* ;for file in `ls /opt/mount1/seals/flume_test/source `; do  cp /opt/mount1/seals/flume_test/source/$file /opt/mount1/seals/flume_test/logs/$(date +%Y%m%d.%H%M%S).$file; sleep 2; done



#Clear DFS
if you need to reformat hadoop dfs, please run the script.
make sure you have stop the hadoop cluster.
///  /home/grid/code/cleardfs.sh aa0[2,3,4,5,6]
///  /usr/hadoop/bin/hdfs namenode -format

#hbase
$hbase_home/bin/hbase shell

create 'test', 'cf'
list 'test'
put 'test', 'row1', 'cf:a', 'value1'
put 'test', 'row2', 'cf:b', 'value2'
put 'test', 'row3', 'cf:c', 'value3'
scan 'test'
get 'test', 'row1'
#fail to drop 'test'
disable 'test'
#enable 'test'
drop 'test'

create_namespace 'ns1'
create 'ns1:t1', 'f1', SPLITS => ['10', '20', '30', '40']
create 't1', 'f1', SPLITS => ['10', '20', '30', '40']

scan 'hbase:meta'
scan 'hbase:meta', {COLUMNS => 'info:regioninfo'}
scan 'ns1:t1'







