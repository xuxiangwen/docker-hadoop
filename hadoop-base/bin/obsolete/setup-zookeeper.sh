#!/bin/bash
script=$(readlink -f "$0")
scriptpath=$(dirname "$script")
source $scriptpath/config.`hostname`

$scriptpath/software-untar.sh $zookeeper_home $zookeeper_folder $zookeeper_jar


localHostName=`hostname`
dataDir=$zookeeper_home/data
dataLogDir=$zookeeper_home/logs
declare -a zookeeper_servers_cwp=\(\"${zookeeper_servers//,/\" \"}\"\)

echo mkdir -p $dataDir
mkdir -p $dataDir

echo mkdir $dataLogDir
mkdir -p $dataLogDir

echo set $zookeeper_home/conf/zoo.cfg
echo tickTime=2000                 >  $zookeeper_home/conf/zoo.cfg
echo dataDir=$dataDir              >> $zookeeper_home/conf/zoo.cfg
echo dataLogDir=$dataLogDir        >> $zookeeper_home/conf/zoo.cfg
echo clientPort=$zookeeper_port    >> $zookeeper_home/conf/zoo.cfg
echo initLimit=10                  >> $zookeeper_home/conf/zoo.cfg
echo syncLimit=5                   >> $zookeeper_home/conf/zoo.cfg

i=1
for server in "${zookeeper_servers_cwp[@]}"
do
echo server.${i}=$server:2888:3888 >> $zookeeper_home/conf/zoo.cfg
let i++
done

echo set $dataDir/myid
i=1
for server in "${zookeeper_servers_cwp[@]}"
do
  if [ $server = $localHostName ]  
  then 
    echo $i > $dataDir/myid
    break
  fi
  let i++
done

$scriptpath/command-with-text.sh " cat $zookeeper_home/conf/zoo.cfg"
$scriptpath/command-with-text.sh " cat $dataDir/myid"

echo setup zookeeper is finished on `hostname`

