#!/bin/bash
script=$(readlink -f "$0")
scriptpath=$(dirname "$script")
source $scriptpath/config.`hostname`

while read line
do
if [[ $line =~ ^[a-zA-Z0-9_]+=.+$ ]] 
then
  var_string="echo ${line/=*/}=\$${line/=*/}"
  eval $var_string 
else
  echo $line
fi
done  < $scriptpath/config.`hostname`




