from https://github.com/CentOS/CentOS-Dockerfiles/tree/master/ssh/centos7

docker stop centos-ssh
docker rmi  microsheen/ssh:centos7
docker build --rm -t microsheen/ssh:centos7 .
docker run --name centos-ssh  --rm  -d  microsheen/ssh:centos7
docker exec -it  centos-ssh bash


