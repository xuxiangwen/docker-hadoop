#!/bin/bash
script=$(readlink -f "$0")
scriptpath=$(dirname "$script")
source $scriptpath/../conf/config.sh

$scriptpath/line.sh "hadoop setup"
$scriptpath/slaves.sh $hadoop_home/etc/hadoop/slaves $hadoop_slaves
$scriptpath/command.sh " cat $hadoop_home/etc/hadoop/slaves "

$scriptpath/line.sh "spark setup"
$scriptpath/slaves.sh $spark_home/conf/slaves $spark_slaves
$scriptpath/command.sh " cat $spark_home/conf/slaves" 

$scriptpath/line.sh "start ssh server"
sudo /usr/sbin/sshd 


$scriptpath/command.sh " tail -f /dev/null"
