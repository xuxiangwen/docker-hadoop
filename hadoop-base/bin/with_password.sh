#!/bin/bash
script=$(readlink -f "$0")
scriptpath=$(dirname "$script")
source $scriptpath/../conf/config.sh

ssh -o "StrictHostKeyChecking no" $hadoop_master hostname
declare -a slaves_cwp=\(\"${hadoop_slaves//,/\" \"}\"\)

for slave in "${slaves_cwp[@]}"
do
  ssh -o "StrictHostKeyChecking no" $slave hostname
done
