#!/bin/bash
script=$(readlink -f "$0")
scriptpath=$(dirname "$script")
source $aa_path/conf/config.sh

$aa_path/bin/with_password.sh  
$hadoop_home/sbin/start-dfs-origin.sh
hadoop fs -mkdir -p $spark_eventLog_dir 




