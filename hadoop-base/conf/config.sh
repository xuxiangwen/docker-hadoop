#!/bin/bash
# ----------------------------------------
# base information
# ----------------------------------------
user=grid
repository_path=$aa_path/repository

# ----------------------------------------
# net proxy
# ----------------------------------------
http_proxy=http://web-proxy.rose.hp.com:8080
https_proxy=http://web-proxy.rose.hp.com:8080

# ----------------------------------------
# java
# wget https://download.java.net/java/jdk8u172/archive/b03/binaries/jdk-8u172-ea-bin-b03-linux-x64-18_jan_2018.tar.gz
# ----------------------------------------
java_home=$aa_path/java
java_folder=$aa_path/jdk1.8.0_172
java_jar=$file_server/jdk-8u172-ea-bin-b03-linux-x64-18_jan_2018.tar.gz
java_download=https://download.java.net/java/jdk8u172/archive/b03/binaries/jdk-8u172-ea-bin-b03-linux-x64-18_jan_2018.tar.gz

# ----------------------------------------
# scala
# ----------------------------------------
scala_home=$aa_path/scala
scala_folder=$aa_path/scala-2.11.8
scala_jar=$file_server/scala-2.11.8.tgz
scala_download=https://downloads.lightbend.com/scala/2.11.8/scala-2.11.8.tgz

# ----------------------------------------
# hadoop: http://mirror.stjschools.org/public/apache/hadoop/common/hadoop-2.7.5/hadoop-2.7.5.tar.gz
# ----------------------------------------
hadoop_master=master
hadoop_home=$aa_path/hadoop
hadoop_folder=$aa_path/hadoop-2.7.5
hadoop_jar=$file_server/hadoop-2.7.5.tar.gz
hadoop_download=http://mirror.stjschools.org/public/apache/hadoop/common/hadoop-2.7.5/hadoop-2.7.5.tar.gz

hadoop_hdfs_port=9000

hadoop_name_dir=$hadoop_home/hdfs/name
hadoop_data_dir=$hadoop_home/hdfs/data
hadoop_tmp_dir=$hadoop_home/tmp/hadoop
hadoop_log_dir=$hadoop_home/log/hadoop

yarn_log_dir=$hadoop_home/log/yarn

# ----------------------------------------
# spark: http://mirrors.ocf.berkeley.edu/apache/spark/spark-2.2.1/spark-2.2.1-bin-hadoop2.7.tgz
# ----------------------------------------
spark_master=master
spark_home=$aa_path/spark
spark_folder=$aa_path/spark-2.2.1-bin-hadoop2.7
spark_jar=$file_server/spark-2.2.1-bin-hadoop2.7.tgz
spark_download=http://mirrors.ocf.berkeley.edu/apache/spark/spark-2.2.1/spark-2.2.1-bin-hadoop2.7.tgz

spark_driver_memory=2g
spark_eventLog_dir=$spark_home/event
spark_tmp_dir=$spark_home/tmp
spark_log_dir=$spark_home/log

