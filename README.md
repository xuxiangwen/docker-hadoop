这是一个基于docker的hadoop和spark集群。本集群的特点有：

1. 基于docker swarm， 支持单机和多机。 
2. 基于centos7构建的image，满足喜欢折腾centos的同学。  


# 集群

## 配置
### 配置docker-compose.yml
在docker-compose.yml可以配置多个slave。


## 启动
docker stack deploy -c docker-compose.yml hadoop  #部署    
watch -n 10 "docker stack ps hadoop"  #检查部署状态。第一次的时候，因为每个机器都需要到docker hub上下载大小1.2GB的image，所以需要一定的时间。直到所有的容器全部启动完成（每个容器的CURRENT STATE从Preparing about \*\*\*变成Running about \*\*\*），再进行下一步。


# Hadoop   
## 启动Hadoop   
docker exec -it hadoop_master.1.$(docker service ps hadoop_master -q -f "desired-state=running") bash  #登录master节点      
hdfs namenode -format      #注意在容器启动之后，第一次  

start-dfs.sh  
start-yarn.sh  


## 验证Hadoop
### shell  
pdsh -R ssh -w grid@$hadoop_master,$hadoop_slaves jps | grep -E "NameNode|DataNode|ResourceManager|NodeManager"    
hdfs dfsadmin -report  

### monitor
http://aa00:50070/dfshealth.html  
http://aa00:8088/cluster/nodes  

## 测试  
hadoop fs -mkdir -p /input  
hadoop fs -put $aa_path/bin/*.sh /input  
hadoop fs -ls /input  

hadoop fs -mkdir -p /output  
hadoop fs -rm -r /output/wordcount  
yarn jar $aa_path/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.5.jar wordcount /input /output/wordcount  
hadoop fs -cat /output/wordcount/*  


# Spark  
## 启动Spark  
$aa_path/spark/sbin/start-all.sh  
$aa_path/spark/sbin/start-history-server.sh  


## 验证Spark  
### shell  
pdsh -R ssh -w grid@master,$spark_slaves jps | grep -E "Master|Worker|HistoryServer"  

### monitor  
http://aa00:8080  

## 测试
$aa_path/spark/bin/spark-submit --master spark://master:7077 --class org.apache.spark.examples.JavaWordCount $aa_path/spark/examples/jars/spark-examples_2.11-2.2.1.jar /input/entrypoint.sh  
$aa_path/spark/bin/spark-submit --master yarn --deploy-mode client --class org.apache.spark.examples.JavaWordCount $aa_path/spark/examples/jars/spark-examples_2.11-2.2.1.jar /input/entrypoint.sh  
$aa_path/spark/bin/spark-submit --master yarn --deploy-mode cluster --class org.apache.spark.examples.JavaWordCount $aa_path/spark/examples/jars/spark-examples_2.11-2.2.1.jar /input/entrypoint.sh  

# 停止  
## 停止集群  
docker stack rm hadoop  

## 停止Hadoop  
stop-yarn.sh  
stop-dfs.sh  

## 停止spark  
$aa_path/spark/sbin/stop-all.sh  
$aa_path/spark/sbin/stop-history-server.sh  



# 其他实验命令（不保证一定成功） 
ssh grid@aa00 mkdir -p /opt/mount1/aa/master/hadoop/hdfs/name  
ssh grid@aa01 mkdir -p /opt/mount1/aa/slave1/hadoop/hdfs/data  
ssh grid@aa02 mkdir -p /opt/mount1/aa/slave2/hadoop/hdfs/data  
ssh grid@aa03 mkdir -p /opt/mount1/aa/slave3/hadoop/hdfs/data  

slave_number=1;docker exec -it $(docker ps  | grep  hadoop_slave$slave_number | awk '{print $NF}') bash  
slave_number=2;docker exec -it $(docker ps  | grep  hadoop_slave$slave_number | awk '{print $NF}') bash  
slave_number=3;docker exec -it $(docker ps  | grep  hadoop_slave$slave_number | awk '{print $NF}') bash  

