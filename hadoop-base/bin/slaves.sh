#!/bin/bash
script=$(readlink -f "$0")
scriptpath=$(dirname "$script")

slave_file=$1
slaves=$2

declare -a slaves_cwp1=\(\"${slaves//,/\" \"}\"\)

rm -rf $slave_file

for slave in "${slaves_cwp1[@]}"
do
  echo $slave >> $slave_file
done









