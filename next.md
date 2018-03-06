# 其他实验命令（不保证一定成功） 
docker stack deploy -c docker-compose-registry.yml hadoop 

ssh grid@aa00 mkdir -p /opt/mount1/aa/master/hadoop/hdfs/name  
ssh grid@aa01 mkdir -p /opt/mount1/aa/slave1/hadoop/hdfs/data  
ssh grid@aa02 mkdir -p /opt/mount1/aa/slave2/hadoop/hdfs/data  
ssh grid@aa03 mkdir -p /opt/mount1/aa/slave3/hadoop/hdfs/data  

docker exec -it $(docker ps | grep hadoop_master | awk '{print $NF}') bash
slave_number=1;docker exec -it $(docker ps  | grep  hadoop_slave$slave_number | awk '{print $NF}') bash  
slave_number=2;docker exec -it $(docker ps  | grep  hadoop_slave$slave_number | awk '{print $NF}') bash  
slave_number=3;docker exec -it $(docker ps  | grep  hadoop_slave$slave_number | awk '{print $NF}') bash  

#这两个会失败，寻找原因中。
$aa_path/spark/bin/spark-submit --master yarn --deploy-mode client --class org.apache.spark.examples.JavaWordCount $aa_path/spark/examples/jars/spark-examples_2.11-2.2.1.jar /input/entrypoint.sh  
$aa_path/spark/bin/spark-submit --master yarn --deploy-mode cluster --class org.apache.spark.examples.JavaWordCount $aa_path/spark/examples/jars/spark-examples_2.11-2.2.1.jar /input/entrypoint.sh  
