这是一个docker的hadoop和spark集群。本集群的特点有：

1. 基于docker swarm， 支持单机和多机。docker swarm的安装参考  https://yeasy.gitbooks.io/docker_practice/content/swarm/
2. 基于centos7构建的image，满足喜欢折腾centos的同学。  
3. 集成了验证和测试的脚本，方便检查集群状态。


# 1. 集群

## 配置
### 配置docker-compose.yml
在docker-compose.yml可以配置多个slave。

```
version: '3'

services:
  master:
    image: microsheen/hadoop-base:latest
    hostname: master
    env_file:
      - ./cluster.env    
    ports:
      - "50070:50070"
      - "9000:9000"             
      - "8080:8080"
      - "8088:8088"
      - "18080:18080"    
    deploy:
      placement:
        constraints: [node.role == manager]       
    networks:
      - net       

  slave1:
    image: microsheen/hadoop-base:latest
    hostname: slave1
    depends_on:
      - master
    env_file:
      - ./cluster.env
    networks:
      - net            
  
  slave2:
    image: microsheen/hadoop-base:latest
    hostname: slave2
    depends_on:
      - master
    env_file:
      - ./cluster.env         
    networks:
      - net            
      
  slave3:
    image: microsheen/hadoop-base:latest
    hostname: slave3
    depends_on:
      - master
    env_file:
      - ./cluster.env              
    networks:
      - net   
  
networks:
  net:   
```

### 编辑cluster.env
保证里面的slaves的机器和docker-compose.yml相同。
```
# ----------------------------------------
# hdoop
# ----------------------------------------
hadoop_slaves=slave1,slave2,slave3

# ----------------------------------------
# spark
# ----------------------------------------
spark_slaves=slave1,slave2,slave3
```


## 启动
```bash
docker stack deploy -c docker-compose.yml hadoop  #部署      

#检查部署状态。直到所有的容器全部启动完成
#当每个容器的CURRENT STATE从Preparing about \*\*\*变成Running about \*\*\*），再进行下一步。   
#第一次的时候，时间需要长一些。这是因为每个机器都需要到docker hub上下载image，所以需要一定的时间。   
watch -n 10 "docker stack ps hadoop"      
```


# 2. Hadoop    
## 启动Hadoop   
```bash
#登录master节点    
docker exec -it hadoop_master.1.$(docker service ps hadoop_master -q -f "desired-state=running") bash       
hdfs namenode -format      #注意在容器启动之后，第一次需要格式化

start-dfs.sh  
start-yarn.sh  
```


## 验证Hadoop
### shell  
```bash
pdsh -R ssh -w grid@master,$hadoop_slaves jps | grep -E "NameNode|DataNode|ResourceManager|NodeManager"   
hdfs dfsadmin -report  
```

### monitor
在swarm mananger的节点上。

http://localhost:50070/dfshealth.html  
http://localhost:8088/cluster/nodes  

## 测试  
```bash
hadoop fs -mkdir -p /input  
hadoop fs -put $aa_path/bin/*.sh /input  
hadoop fs -ls /input  

hadoop fs -mkdir -p /output  
hadoop fs -rm -r /output/wordcount  
yarn jar $aa_path/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.5.jar wordcount \
/input /output/wordcount 
hadoop fs -cat /output/wordcount/*
```


# 3. Spark   
## 启动Spark  
```bash
$aa_path/spark/sbin/start-all.sh  
$aa_path/spark/sbin/start-history-server.sh  
```


## 验证Spark  
### shell  
```bash
pdsh -R ssh -w grid@master,$spark_slaves jps | grep -E "Master|Worker|HistoryServer"  
```

### monitor  
http://localhost:8080  

## 测试
```bash
$aa_path/spark/bin/spark-submit --master spark://master:7077 \
--class org.apache.spark.examples.JavaWordCount $aa_path/spark/examples/jars/spark-examples_2.11-2.2.1.jar \
/input/entrypoint.sh  
```

# 4. 停止   
## 停止集群  
```bash
docker stack rm hadoop  
```

## 停止Hadoop  
```bash
stop-yarn.sh  
stop-dfs.sh  
```

## 停止spark  
```bash
$aa_path/spark/sbin/stop-all.sh  
$aa_path/spark/sbin/stop-history-server.sh  
```



