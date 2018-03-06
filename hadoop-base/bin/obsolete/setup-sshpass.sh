#!/bin/bash
script=$(readlink -f "$0")
scriptpath=$(dirname "$script")
source $scriptpath/config.`hostname`

if [ ! -e /usr/local/bin/sshpass ]
then
  cd $targetpath/software
  tar xvf sshpass-1.05.tar.gz
  cd sshpass-1.05
  ./configure  
  make
  sudo make install
fi

