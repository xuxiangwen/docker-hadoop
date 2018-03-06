#!/bin/bash
script=$(readlink -f "$0")
scriptpath=$(dirname "$script")
source $scriptpath/config.`hostname`

$scriptpath/software-untar.sh $scala_home $scala_folder $scala_jar

if [ ! -e /usr/local/bin/python ]
then
  cd $aapath/python
  ./configure
  make
  sudo make install
fi

