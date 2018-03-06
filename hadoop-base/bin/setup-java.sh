#!/bin/bash
script=$(readlink -f "$0")
scriptpath=$(dirname "$script")
source $scriptpath/../conf/config.sh

$scriptpath/line.sh "start setup-java.sh"
$scriptpath/command.sh "$scriptpath/tar.sh $java_home $java_folder $java_jar $java_download"

$scriptpath/text.sh 'create /etc/profile.d/java.sh'
echo export JAVA_HOME=$java_home  > $scriptpath/java.sh
echo export JRE_HOME='$JAVA_HOME/jre' >> $scriptpath/java.sh
echo export CLASSPATH='.:$JAVA_HOME/lib:$JRE_HOME/lib:$JAVA_HOME/lib/tools.jar:$CLASSPATH' >> $scriptpath/java.sh
echo export PATH='$JAVA_HOME/bin:$JRE_HOME/bin:$PATH' >> $scriptpath/java.sh
sudo mv $scriptpath/java.sh /etc/profile.d

$scriptpath/command.sh "ls -l $java_home"
$scriptpath/command.sh "ls -l $aapath | grep $java_folder"
$scriptpath/command.sh "cat /etc/profile.d/java.sh"

$scriptpath/line.sh "finish setup-java.sh"

