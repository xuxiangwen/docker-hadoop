#!/bin/bash
script=$(readlink -f "$0")
scriptpath=$(dirname "$script")
cp $scriptpath/config.`hostname` $scriptpath/config.sh
source $scriptpath/config.`hostname`

sudo yum install -y nodejs npm
sudo npm install -g bower
rm -rf ~/.bowerrc
echo {                                                                 >> ~/.bowerrc
echo       \"proxy\": \"http://web-proxy.atl.hp.com:8080\",            >> ~/.bowerrc
echo       \"https-proxy\": \"http://web-proxy.atl.hp.com:8080\"       >> ~/.bowerrc
echo }                                                                 >> ~/.bowerrc

npm config set proxy http://web-proxy.atl.hp.com:8080
npm config set https-proxy http://web-proxy.atl.hp.com:8080


oldpath=`pwd`
cd $aapath

#if [ ! -d $aapath/zeppelin-0.5.5-incubating  ]
#then
#  wget http://mirror.olnevhost.net/pub/apache/incubator/zeppelin/0.5.5-incubating/zeppelin-0.5.5-incubating.tgz
#  tar -zxf zeppelin-0.5.5-incubating.tgz -C $aapath
#  rm -rf zeppelin-0.5.5-incubating.tgz
#fi

#rm -rf $aapath/incubator-zeppelin
#ln -s $aapath/zeppelin-0.5.5-incubating $aapath/incubator-zeppelin


if [ ! -d $aapath/incubator-zeppelin  ]
then 
  cd $aapath
  git config --global http.proxy http://web-proxy.atl.hp.com:8080
  git clone https://github.com/apache/incubator-zeppelin.git
fi

cd $aapath/incubator-zeppelin
mvn clean package -DskipTests -Pspark-1.5 -Phadoop-2.6 
#mvn package -DskipTests -Pspark-1.5 -Phadoop-2.6 
#need to remove some modules if they can not be installed successfully

# if [ ! -d $aapath/incubator-zeppelin  ]
# then 
  # wget http://www.carfab.com/apachesoftware/incubator/zeppelin/0.5.5-incubating/zeppelin-0.5.5-incubating-bin-all.tgz
  # tar -zxf zeppelin-0.5.5-incubating-bin-all.tgz -C $aapath
  # mv  zeppelin-0.5.5-incubating-bin-all incubator-zeppelin
  # rm -rf zeppelin-0.5.5-incubating-bin-all.tgz
# fi   
# cd $aapath/incubator-zeppelin

echo mkdir $zeppelin_notebook_dir
mkdir -p $zeppelin_notebook_dir



cp conf/zeppelin-env.sh.template conf/zeppelin-env.sh
echo export MASTER=spark://$spark_master:7077                                      >> conf/zeppelin-env.sh
echo export SPARK_HOME=$spark_home                                                 >> conf/zeppelin-env.sh
echo export SPARK_SUBMIT_OPTIONS=\"--driver-memory 512M --executor-memory 1G\"     >> conf/zeppelin-env.sh
echo export HADOOP_CONF_DIR==$hadoop_home/etc/hadoop                               >> conf/zeppelin-env.sh
echo export ZEPPELIN_PORT=9090                                                     >> conf/zeppelin-env.sh
echo export ZEPPELIN_NOTEBOOK_DIR=$zeppelin_notebook_dir                           >> conf/zeppelin-env.sh
echo #export ZEPPELIN_JAVA_OPTS="-Dspark.executor.memory=2g -Dspark.cores.max=4"   >> conf/zeppelin-env.sh

cp conf/zeppelin-site.xml.template conf/zeppelin-site.xml

cd $oldpath

