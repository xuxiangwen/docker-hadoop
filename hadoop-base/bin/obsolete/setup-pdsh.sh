#!/bin/bash
script=$(readlink -f "$0")
scriptpath=$(dirname "$script")
source $scriptpath/config.`hostname`

if [ ! -e /usr/local/bin/pdsh ]
then
  cd $targetpath/software
  ll
  sudo rm -rf $targetpath/software/pdsh-2.29
  tar jxvf pdsh-2.29.tar.bz2
  cd pdsh-2.29
  ./configure --with-ssh --with-rsh 
  make
  sudo make install
fi

