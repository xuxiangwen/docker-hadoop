#!/bin/bash
script=$(readlink -f "$0")
scriptpath=$(dirname "$script")
source $scriptpath/config.`hostname`

echo 'set /etc/profile.d/cluster-install.sh'
echo export PATH=$scriptpath:'$PATH' > $targetpath/cluster-install.sh
sudo mv $targetpath/cluster-install.sh /etc/profile.d

$scriptpath/command-with-text.sh "cat /etc/profile.d/cluster-install.sh"

