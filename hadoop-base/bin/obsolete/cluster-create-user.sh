#!/bin/bash
script=$(readlink -f "$0")
scriptpath=$(dirname "$script")
source $scriptpath/config.`hostname`

orignaluser=$1
orignalpassword=$2
user1=${3:-$user}
password1=${4:-$password}

for server in "${servers_cwp[@]}"
do
  echo $server 
  ~/cluster/cluster-install/create-user.sh $server $orignaluser $orignalpassword $user1 $password1
done

