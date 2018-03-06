#!/bin/bash
script=$(readlink -f "$0")
scriptpath=$(dirname "$script")
source $scriptpath/config.`hostname`

$scriptpath/software-untar.sh $hbase_home $hbase_folder $hbase_jar


echo set $hbase_home/conf
cp $scriptpath/hbase/hbase-env.sh $hbase_home/conf/hbase-env.sh
cp $scriptpath/hbase/hbase-site.xml $hbase_home/conf/hbase-site.xml

rootdir=${hbase_rootdir//\//\\\/}
sed -i "s/{hbase_rootdir}/$rootdir/g"      $hbase_home/conf/hbase-site.xml
sed -i "s/{hbase_zookeeper_property_clientPort}/$hbase_zookeeper_property_clientPort/g" $hbase_home/conf/hbase-site.xml
sed -i "s/{hbase_zookeeper_quorum}/$hbase_zookeeper_quorum/g" $hbase_home/conf/hbase-site.xml

$scriptpath/slaves.sh $hbase_home/conf/regionservers $hbase_master $hbase_servers
echo $hbase_backup_masters > $hbase_home/conf/backup-masters

$scriptpath/command-with-text.sh " ls -l $hbase_home"
$scriptpath/command-with-text.sh " ls -l $aapath | grep $hbase_folder"
$scriptpath/command-with-text.sh " cat $hbase_home/conf/hbase-site.xml"
$scriptpath/command-with-text.sh " cat $hbase_home/conf/regionservers"
$scriptpath/command-with-text.sh " cat $hbase_home/conf/backup_masters"

echo setup hbase is finished on `hostname` 
echo "===================================================================="


