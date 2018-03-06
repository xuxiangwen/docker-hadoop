00 start-stop.sh
05 before-config.sh
06 cluster-create-user.sh
    06.1 create-user.sh
10 config.sh
    10.1 config.sh.aa01.sh
    10.2 config.c1t14285.itcs.hpicorp.net.sh
    10.3 print-config.sh
    10.4 command-with-text.sh
    10.5 for-command.sh
15 net-proxy.sh
20 cluster-without-password.sh    
    20.1 without-password.sh
30 setup-environment.sh
    30.1 setup-pdsh.sh
32 setup-yum-software.sql  optional
33 software_untar.sh
40 setup-java.sh
41 setup-scala.sh
42 setup-python.sh
48 slaves.sh
50 setup-hadoop.sh
55 setup-flume.sh
60 setup-spark.sh
65 setup-shiny.sh
70 setup-zookeeper.sh
75 setup-kafka.sh
80 setup-hbase.sh
100 set-cluster-install-path.sh

source ~/eipi10/cluster-install/config.`hostname`
source ~/cluster-install/config.`hostname`
  
export servers_test=aa02

#00 start-stop.sh
start-stop.sh

#05 before config.sh
vim ~/eipi10/cluster-install/before-config.sh
~/eipi10/cluster-install/cluster-create-user.sh grid grid

#10 change config.sh
vim ~/eipi10/cluster-install/config.`hostname`
~/eipi10/cluster-install/print-config.sh

#15 set net proxy
sudo ~/eipi10/cluster-install/net-proxy.sh

#20 set cluster without password
~/eipi10/cluster-install/cluster-without-password.sh

#30 set environment
~/eipi10/cluster-install/setup-environment.sh

#32  install some yum software  (optional)   
#if installing pdsh fails, try to install gcc first and then run setup-environment again
~/eipi10/cluster-install/setup-yum-software.sh  gcc

#33 同步时间
#chrony 时间同步  
#http://www.ywnds.com/?p=6079
#
source ~/cluster-install/config.`hostname`
pdsh -R ssh -w $user@$servers sudo yum install chrony
pdsh -R ssh -w $user@$servers sudo systemctl start chronyd.service
pdsh -R ssh -w $user@$servers sudo systemctl enable chronyd.service
pdsh -R ssh -w $user@$servers sudo systemctl status chronyd.service


sudo vim /etc/chrony.conf
#in server
local stratum 10
allow 15.15.165.218
allow 15.15.165.35
allow 15.15.166.231
allow 15.15.166.234

#in client
server 15.15.165.218 iburst
allow 15.15.165.218
allow 15.15.165.35
allow 15.15.166.231
allow 15.15.166.234

sudo systemctl restart chronyd.service
chronyc sources -v
chronyc sourcestats -v

pdsh -R ssh -w $user@$servers chronyc sources -v
pdsh -R ssh -w $user@$servers date
pdsh -R ssh -w $user@$servers timedatectl   


#40 setup some basic development framework
pdsh -R ssh -w $user@$servers $targetpath/setup-java.sh
pdsh -R ssh -w $user@$servers java -version
pdsh -R ssh -w $user@$servers $targetpath/setup-scala.sh
pdsh -R ssh -w $user@$servers scala -version
pdsh -R ssh -w $user@$servers $targetpath/setup-python.sh



#45 clear software
pdsh -R ssh -w $user@$servers rm -rf $aapath/$hadoop_folder
pdsh -R ssh -w $user@$servers rm -rf $hadoop_home
pdsh -R ssh -w $user@$servers rm -rf $aapath/$spark_folder
pdsh -R ssh -w $user@$servers rm -rf $spark_home

#46 setup maven
wget http://mirrors.hust.edu.cn/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
tar zxvf apache-maven-3.3.9-bin.tar.gz -C /opt/mount1/aa
ln -s /opt/mount1/aa/apache-maven-3.3.9 /opt/mount1/aa/maven
targetpath=/opt/mount1/aa/maven
echo export M2_HOME=/opt/mount1/aa/maven   >  $targetpath/maven.sh
echo export PATH='$PATH:$M2_HOME/bin' >> $targetpath/maven.sh
sudo mv $targetpath/maven.sh /etc/profile.d
source /etc/profile
#maven web proxy
cp ~/cluster-install/maven/settings.xml ~/.m2/


#50 setup hadoop
source ~/cluster-install/config.`hostname`
pdsh -R ssh -w $user@$servers $targetpath/setup-hadoop.sh
#安装验证
pdsh -R ssh -w $user@$servers ls -ld  $aapath/$hadoop_folder
pdsh -R ssh -w $user@$servers hadoop version
start-dfs.sh  #if first start, please run "hdfs namenode -format" first.
start-yarn.sh
stop-dfs.sh
stop-yarn.sh

#启动验证
pdsh -R ssh -w $user@$servers jps | grep -E "NameNode|DataNode|ResourceManager|NodeManager"
hdfs dfsadmin -report


#modify the file number of open and number of process
echo grid             -       nofile          32768   >  /tmp/grid.conf
echo grid             -       nproc           32000   >> /tmp/grid.conf
sudo mv /tmp/grid.conf /etc/security/limits.d/grid.conf
sudo chown -R root:root /etc/security/limits.d/grid.conf

#55 setup flume
pdsh -R ssh -w $user@$flume_servers $targetpath/setup-flume.sh
pdsh -R ssh -w $user@$flume_servers $flume_home/bin/flume-ng version

#60 setup spark
pdsh -R ssh -w $user@$servers $targetpath/setup-spark.sh
#安装验证
pdsh -R ssh -w $user@$servers ls -ld  $spark_home
$spark_home/sbin/start-all.sh
$spark_home/sbin/stop-all.sh

$spark_home/sbin/start-history-server.sh
$spark_home/sbin/stop-history-server.sh

#启动验证
pdsh -R ssh -w $user@$servers jps | grep -E "Master|Worker|HistoryServer"

#65 setup zeppelin
~/eipi10/cluster-install/setup-zeppelin.sh 

#shiny server
nginxserver=
shinyserver=

LF
source ~/cluster-install/config.`hostname`
pdsh -R ssh -w $user@$servers sudo mkdir /opt/mount1/seals
pdsh -R ssh -w $user@$servers sudo chown -R grid:grid /opt/mount1/seals

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
$kafka_home/bin/kafka-topics.sh --zookeeper $zookeeper_connect --topic test --replication-factor 2 --partitions 3 --create
$kafka_home/bin/kafka-topics.sh --describe --zookeeper $zookeeper_connect --topic test
#list topic
$kafka_home/bin/kafka-topics.sh --list --zookeeper $zookeeper_connect
#generate message
$kafka_home/bin/kafka-console-producer.sh --broker-list $kafka_connect --topic test
#get message
$kafka_home/bin/kafka-console-consumer.sh --zookeeper $zookeeper_connect --from-beginning --topic test

#get largest offset 
$kafka_home/bin/kafka-run-class.sh kafka.tools.GetOffsetShell  --broker-list $kafka_connect --partitions 0,1,2,3 --topic random_number --time -1

#change partition count
$kafka_home/bin/kafka-topics.sh --alter --zookeeper $zookeeper_connect --topic local.KafkaActorMonitor --partitions 8
$kafka_home/bin/kafka-topics.sh --alter --zookeeper $zookeeper_connect --topic local.LogDataExtractor --partitions 8 
$kafka_home/bin/kafka-topics.sh --alter --zookeeper $zookeeper_connect --topic local.LogDataExtract --partitions 8 
$kafka_home/bin/kafka-topics.sh --alter --zookeeper $zookeeper_connect --topic local.FileToHDFS --partitions 8 
$kafka_home/bin/kafka-topics.sh --alter --zookeeper $zookeeper_connect --topic local.VerticaCopy --partitions 8 

#80 setup hbase
#wget http://apache.claz.org/hbase/1.3.1/hbase-1.3.1-bin.tar.gz
#wget http://apache.claz.org/hbase/2.0.0-alpha-1/hbase-2.0.0-alpha-1-bin.tar.gz
source ~/cluster-install/config.`hostname`
pdsh -R ssh -w $user@$kafka_servers $targetpath/setup-hbase.sh
$hbase_home/bin/start-hbase.sh
$hbase_home/bin/stop-hbase.sh

#http://aa01:16010

#test
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

#100   set-cluster-install-path.sh
#set cluster-install path in  Path(environment variable)
~/cluster-install/set-cluster-install-path.sh