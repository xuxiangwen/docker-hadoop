#!/bin/bash
script=$(readlink -f "$0")
scriptpath=$(dirname "$script")
source $scriptpath/../conf/config.sh

$scriptpath/line.sh "start setup-spark.sh"

#untar
$scriptpath/tar.sh $spark_home $spark_folder $spark_jar $spark_download
$scriptpath/command.sh " ls -ld $spark_home $spark_folder"

#mkdir 
$scriptpath/command.sh "mkdir -p $spark_log_dir"
$scriptpath/command.sh " ls -ld $spark_log_dir"

$scriptpath/text.sh "create /etc/profile.d/spark.sh"
echo export SPARK_HOME=$spark_home  > $spark_home/spark.sh
echo export PATH=\$PATH:\$SPARK_HOME/sbin:\$SPARK_HOME/bin >> $spark_home/spark.sh
sudo mv $spark_home/spark.sh /etc/profile.d
$scriptpath/command.sh " cat /etc/profile.d/spark.sh"

$scriptpath/text.sh "set $spark_home/conf/spark-env.sh"
cp $spark_home/conf/spark-env.sh.template $spark_home/conf/spark-env.sh
echo export JAVA_HOME=$java_home                          >> $spark_home/conf/spark-env.sh
echo export SCALA_HOME=$scala_home                         >> $spark_home/conf/spark-env.sh
echo export SPARK_MASTER_IP=$spark_master                    >> $spark_home/conf/spark-env.sh
echo export HADOOP_HOME=$hadoop_home                        >> $spark_home/conf/spark-env.sh
echo export HADOOP_CONF_DIR=$hadoop_home/etc/hadoop             >> $spark_home/conf/spark-env.sh
echo export SPARK_DRIVER_MEMORY=$spark_driver_memory             >> $spark_home/conf/spark-env.sh
echo export SPARK_HISTORY_OPTS=\"-Dspark.history.ui.port=18080 -Dspark.history.retainedApplications=3 -Dspark.history.fs.logDirectory=hdfs://$hadoop_master:$hadoop_hdfs_port$spark_eventLog_dir\" >> $spark_home/conf/spark-env.sh

$scriptpath/text.sh "set $spark_home/conf/spark-defaults.conf"
cp $spark_home/conf/spark-defaults.conf.template $spark_home/conf/spark-defaults.conf
echo spark.eventLog.enabled true                           >> $spark_home/conf/spark-defaults.conf
echo spark.eventLog.dir hdfs://$spark_master:$hadoop_hdfs_port$spark_eventLog_dir >> $spark_home/conf/spark-defaults.conf
echo spark.eventLog.compress true                           >> $spark_home/conf/spark-defaults.conf


$scriptpath/command.sh " cat $spark_home/conf/spark-env.sh"
$scriptpath/command.sh " cat $spark_home/conf/spark-defaults.conf "

$scriptpath/line.sh "finish setup-spark.sh"



