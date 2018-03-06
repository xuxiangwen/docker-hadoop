#!/bin/bash
script=$(readlink -f "$0")
scriptpath=$(dirname "$script")
source $scriptpath/../conf/config.sh

$scriptpath/line.sh "start setup-hadoop.sh"

#untar
$scriptpath/command.sh "$scriptpath/tar.sh $hadoop_home $hadoop_folder $hadoop_jar $hadoop_download"
$scriptpath/command.sh " ls -dl $hadoop_home $hadoop_folder"

#mkdir
$scriptpath/text.sh "mkdir -p $hadoop_name_dir $hadoop_data_dir $hadoop_tmp_dir $hadoop_log_dir $yarn_log_dir"
mkdir -p $hadoop_name_dir $hadoop_data_dir $hadoop_tmp_dir $hadoop_log_dir $yarn_log_dir
$scriptpath/command.sh " ls -dl $hadoop_name_dir $hadoop_data_dir $hadoop_tmp_dir $hadoop_log_dir $yarn_log_dir"

#env
$scriptpath/text.sh "create /etc/profile.d/hadoop.sh"
echo export HADOOP_HOME=$hadoop_home  > $hadoop_home/hadoop.sh
echo export PATH=\$PATH:\$HADOOP_HOME/sbin:\$HADOOP_HOME/bin >> $hadoop_home/hadoop.sh
echo export HADOOP_CONF_DIR=$hadoop_home/etc/hadoop >> $hadoop_home/hadoop.sh
echo export HADOOP_LOG_DIR=$hadoop_log_dir  >> $hadoop_home/hadoop.sh

echo export HADOOP_YARN_HOME=$hadoop_home >> $hadoop_home/hadoop.sh
echo export YARN_HOME=$hadoop_home >> $hadoop_home/hadoop.sh
echo export YARN_CONF_DIR=$hadoop_home/etc/hadoop >> $hadoop_home/hadoop.sh
echo export YARN_LOG_DIR=$yarn_log_dir  >> $hadoop_home/hadoop.sh

sudo mv $hadoop_home/hadoop.sh /etc/profile.d
$scriptpath/command.sh " cat /etc/profile.d/hadoop.sh"

#hadoop configuration
$scriptpath/text.sh  "set $hadoop_home/etc/hadoop/core-site.xml"
cp $scriptpath/../conf/hadoop/etc/hadoop/core-site.xml $hadoop_home/etc/hadoop
sed -i "s|\${hadoop_master}|${hadoop_master}|g"      $hadoop_home/etc/hadoop/core-site.xml
sed -i "s|\${hadoop_hdfs_port}|${hadoop_hdfs_port}|g"  $hadoop_home/etc/hadoop/core-site.xml
sed -i "s|\${hadoop_tmp_dir}|${hadoop_tmp_dir}|g"     $hadoop_home/etc/hadoop/core-site.xml

$scriptpath/text.sh  "set $hadoop_home/etc/hadoop/hdfs-site.xml"
cp $scriptpath/../conf/hadoop/etc/hadoop/hdfs-site.xml $hadoop_home/etc/hadoop
sed -i "s|\${hadoop_master}|${hadoop_master}|g"       $hadoop_home/etc/hadoop/hdfs-site.xml
sed -i "s|\${hadoop_name_dir}|${hadoop_name_dir}|g"    $hadoop_home/etc/hadoop/hdfs-site.xml
sed -i "s|\${hadoop_data_dir}|${hadoop_data_dir}|g"    $hadoop_home/etc/hadoop/hdfs-site.xml
sed -i "s|\${dfs_replication}|${dfs_replication}|g"    $hadoop_home/etc/hadoop/hdfs-site.xml

$scriptpath/text.sh  "set $hadoop_home/etc/hadoop/mapred-site.xml"
cp $scriptpath/../conf/hadoop/etc/hadoop/mapred-site.xml $hadoop_home/etc/hadoop

$scriptpath/text.sh  "set $hadoop_home/etc/hadoop/yarn-site.xml"
cp $scriptpath/../conf/hadoop/etc/hadoop/yarn-site.xml $hadoop_home/etc/hadoop
sed -i "s|\${hadoop_master}|${hadoop_master}|g"       $hadoop_home/etc/hadoop/yarn-site.xml

$scriptpath/text.sh "set $hadoop_home/etc/hadoop/slaves/hadoop-env.sh"
if ! grep -q -i "^export JAVA_HOME=$java_home$" $hadoop_home/etc/hadoop/hadoop-env.sh
then
  echo export JAVA_HOME=$java_home >> $hadoop_home/etc/hadoop/hadoop-env.sh
fi

$scriptpath/command.sh " cat $hadoop_home/etc/hadoop/core-site.xml "
$scriptpath/command.sh " cat $hadoop_home/etc/hadoop/hdfs-site.xml "
$scriptpath/command.sh " cat $hadoop_home/etc/hadoop/mapred-site.xml "
$scriptpath/command.sh " cat $hadoop_home/etc/hadoop/yarn-site.xml "
$scriptpath/command.sh " cat $hadoop_home/etc/hadoop/hadoop-env.sh "


$scriptpath/line.sh "finish setup-hadoop.sh"

$scriptpath/text.sh "modify start-dfs.sh"
mv $hadoop_home/sbin/start-dfs.sh $hadoop_home/sbin/start-dfs-origin.sh
cp $scriptpath/start-dfs.sh $hadoop_home/sbin



