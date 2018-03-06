#!/bin/bash
script=$(readlink -f "$0")
scriptpath=$(dirname "$script")
source $scriptpath/config.`hostname`

$scriptpath/software-untar.sh $kafka_home $kafka_folder $kafka_jar

echo mkdir $kafka_log_dir
mkdir -p $kafka_log_dir

echo set $kafka_home/conf/server.properties
cat $scriptpath/kafka/server.properties
cp $scriptpath/kafka/server.properties $kafka_home/config/server.properties


localHostName=`hostname`
broker_id=0
declare -a kafka_servers_cwp=\(\"${kafka_servers//,/\" \"}\"\)
i=1
for server in "${kafka_servers_cwp[@]}"
do
  if [ $server = $localHostName ]  
  then 
    broker_id=$i
    break
  fi
  let i++
done

sed -i "s/{broker.id}/$broker_id/g"      $kafka_home/config/server.properties
log_dirs=${kafka_log_dir//\//\\\/}
sed -i "s/{log.dirs}/$log_dirs/g" $kafka_home/config/server.properties
sed -i "s/{zookeeper.connect}/$zookeeper_connect/g" $kafka_home/config/server.properties


$scriptpath/command-with-text.sh " ls -l $kafka_home"
$scriptpath/command-with-text.sh " ls -l $aapath | grep $kafka_folder"
$scriptpath/command-with-text.sh " cat $kafka_home/config/server.properties | grep broker.id" 
$scriptpath/command-with-text.sh " cat $kafka_home/config/server.properties | grep log.dirs" 
$scriptpath/command-with-text.sh " cat $kafka_home/config/server.properties | grep zookeeper.connect" 

echo setup kafka is finished on `hostname`

