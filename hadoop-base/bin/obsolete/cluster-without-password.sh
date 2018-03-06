#!/bin/bash
script=$(readlink -f "$0")
scriptpath=$(dirname "$script")
source $scriptpath/config.`hostname`

for server in "${servers_cwp[@]}"
do
  echo $server 
  $scriptpath/without-password.sh $server $user $password $master
  scp $user@$server:~/.ssh/id_rsa.pub $scriptpath/id_rsa.pub.$server  
  cat $scriptpath/id_rsa.pub.$server >>~/.ssh/authorized_keys
  rm -rf $scriptpath/id_rsa.pub.$server
done

for server in "${servers_cwp[@]}"
do
  ssh $user@$server echo ssh $user@$server successfully
done

