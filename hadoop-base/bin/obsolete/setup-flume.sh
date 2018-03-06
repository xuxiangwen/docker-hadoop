#!/bin/bash
script=$(readlink -f "$0")
scriptpath=$(dirname "$script")
source $scriptpath/config.`hostname`

$scriptpath/software-untar.sh $flume_home $flume_folder $flume_jar

echo set $flume_home/conf/flume-env.sh
cp $flume_home/conf/flume-env.sh.template $flume_home/conf/flume-env.sh
echo export JAVA_HOME=$java_home                                              >> $flume_home/conf/flume-env.sh

$scriptpath/command-with-text.sh " ls -l $flume_home"
$scriptpath/command-with-text.sh " ls -l $aapath | grep $flume_folder"
$scriptpath/command-with-text.sh " cat $flume_home/conf/flume-env.sh"

echo setup flume is finished on `hostname`
