#!/bin/bash
script=$(readlink -f "$0")
scriptpath=$(dirname "$script")
source $scriptpath/../conf/config.sh


$scriptpath/line.sh "start setup-scala.sh"
$scriptpath/command.sh "$scriptpath/tar.sh $scala_home $scala_folder $scala_jar $scala_download"

$scriptpath/text.sh 'set /etc/profile.d/scala.sh'
echo export SCALA_HOME=$scala_home  > $scriptpath/scala.sh
echo export PATH='$SCALA_HOME/bin:$PATH' >> $scriptpath/scala.sh
sudo mv $scriptpath/scala.sh /etc/profile.d

$scriptpath/command.sh "ls -l $scala_home"
$scriptpath/command.sh "ls -l $aapath | grep $scala_folder"
$scriptpath/command.sh "cat /etc/profile.d/scala.sh"

$scriptpath/line.sh "finish setup-scala.sh"




