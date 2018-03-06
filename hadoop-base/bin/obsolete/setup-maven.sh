#!/bin/bash
script=$(readlink -f "$0")
scriptpath=$(dirname "$script")
source $scriptpath/config.`hostname`

if [ ! -e /usr/local/apache-maven-3.3.3/bin/mvn ]
then
  wget http://www.eu.apache.org/dist/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz
  sudo tar -zxf apache-maven-3.3.3-bin.tar.gz -C /usr/local/
  sudo rm -rf /usr/local/bin/mvn
  sudo ln -s /usr/local/apache-maven-3.3.3/bin/mvn /usr/local/bin/mvn
  rm -rf apache-maven-3.3.3-bin.tar.gz
  mvn --version
  cp $scriptpath/maven/settings.xml ~/.m2 
fi