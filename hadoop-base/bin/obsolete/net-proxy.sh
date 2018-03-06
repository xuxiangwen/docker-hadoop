#!/bin/bash
#set net proxy 
script=$(readlink -f "$0")
scriptpath=$(dirname "$script")
source $scriptpath/config.`hostname`
if [ ! "$http_proxy" = "" ]
then 
  if ! grep -q -i "^proxy=$http_proxy$" /etc/yum.conf; then echo proxy=$http_proxy | sudo tee -a /etc/yum.conf; fi
  if ! grep -q -i "^http_proxy=$http_proxy$" /etc/profile ; then echo http_proxy=$http_proxy | sudo tee -a /etc/profile ; fi
  if ! grep -q -i "^https_proxy=$http_proxy$" /etc/profile ; then echo https_proxy=$https_proxy | sudo tee -a /etc/profile ; fi
  if ! grep -q -i "^http_proxy=$http_proxy$" /etc/wgetrc ; then echo http_proxy=$http_proxy | sudo tee -a /etc/wgetrc ; fi
  if ! grep -q -i "^https_proxy=$https_proxy$" /etc/wgetrc ; then echo https_proxy=$https_proxy | sudo tee -a /etc/wgetrc ; fi
fi 
source /etc/profile


