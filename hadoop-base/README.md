** download softare    
wget -P ./software https://download.java.net/java/jdk8u172/archive/b03/binaries/jdk-8u172-ea-bin-b03-linux-x64-18_jan_2018.tar.gz    
wget -P ./software https://downloads.lightbend.com/scala/2.11.8/scala-2.11.8.tgz  
wget -P ./software http://mirror.stjschools.org/public/apache/hadoop/common/hadoop-2.7.5/hadoop-2.7.5.tar.gz    
wget -P ./software http://mirrors.ocf.berkeley.edu/apache/spark/spark-2.2.1/spark-2.2.1-bin-hadoop2.7.tgz   
  
**  create image  
cd /home/grid/eipi10/docker-hadoop/hadoop-base  
docker stop hadoop-base-1  
docker rmi --force 127.0.0.1:9900/hadoop-base:latest  
docker build -t 127.0.0.1:9900/hadoop-base:latest .  
docker push 127.0.0.1:9900/hadoop-base:latest #update to registry
docker tag  127.0.0.1:9900/hadoop-base:latest microsheen/hadoop-base:latest
docker push microsheen/hadoop-base:latest

docker run -u grid -it --env-file  ../cluster.env -d  --name hadoop-base-1 --rm 127.0.0.1:9900/hadoop-base:latest
docker exec -it hadoop-base-1 bash
cat hadoop/etc/hadoop/core-site.xml 

