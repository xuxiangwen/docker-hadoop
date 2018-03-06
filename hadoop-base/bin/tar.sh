#!/bin/bash
script=$(readlink -f "$0")
scriptpath=$(dirname "$script")

software_home=$1
software_folder=$2
software_file_server=$3
software_download=$4


$scriptpath/command.sh "rm -rf $software_home"

if [ ! -d $software_folder  ]
then
   jar_file=$(basename "$software_file_server")
   $scriptpath/command.sh "wget --quiet --no-proxy  -O $jar_file  $software_file_server"
     
   $scriptpath/command.sh "mkdir $software_folder "
   $scriptpath/command.sh "tar zxf $jar_file  -C $software_folder --strip-components 1 "
   $scriptpath/command.sh "rm -rf $jar_file"
fi

$scriptpath/command.sh "ln -s $software_folder $software_home"


