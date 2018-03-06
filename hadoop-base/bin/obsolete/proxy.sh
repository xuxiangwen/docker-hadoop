#!/bin/bash
script=$(readlink -f "$0")
scriptpath=$(dirname "$script")

useproxy=$1
if [[ $useproxy -eq "" ]]; then
  http_host=web-proxy.rose.hp.com
  http_port=8080
  https_host=web-proxy.rose.hp.com
  https_port=8080
  http_proxy=http://$http_host:$http_port
  https_proxy=https://$https_host:$http_port 
else
  http_host= 
  http_port= 
  https_host= 
  https_port=  
  http_proxy=
  https_proxy=
fi

echo 
echo http_host=$http_host     > $scriptpath/proxy.conf
echo http_port=$http_port     >> $scriptpath/proxy.conf
echo https_host=$https_host   >> $scriptpath/proxy.conf
echo https_port=$https_port   >> $scriptpath/proxy.conf
echo http_proxy=$http_proxy   >> $scriptpath/proxy.conf
echo https_proxy=$https_proxy >> $scriptpath/proxy.conf


sudo cp $scriptpath/proxy/profile /etc/profile
echo http_proxy=$http_proxy   | sudo tee -a /etc/profile
echo https_proxy=$https_proxy | sudo tee -a /etc/profile
source /etc/profile
sudo cp $scriptpath/proxy/wgetrc /etc/wgetrc
echo http_proxy=$http_proxy   | sudo tee -a /etc/wgetrc
echo https_proxy=$https_proxy | sudo tee -a /etc/wgetrc
sudo cp $scriptpath/proxy/yum.conf /etc/yum.conf
echo proxy=$http_proxy   | sudo tee -a /etc/yum.conf

echo
echo tail -n 5 /etc/profile
tail -n 5 /etc/profile

echo 
echo tail -n 5 /etc/wgetrc
tail -n 5 /etc/wgetrc

echo
echo tail -n 5 /etc/yum.conf
tail -n 5 /etc/yum.conf

echo
echo cat $scriptpath/proxy.conf
cat $scriptpath/proxy.conf

echo git config --global http.proxy "$http_proxy"
git config --global http.proxy "$http_proxy"
echo git config --global https.proxy "$https_proxy"
git config --global https.proxy "$https_proxy"
