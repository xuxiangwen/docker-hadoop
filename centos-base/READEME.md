docker stop centos-base-1
docker rmi --force 127.0.0.1:9900/centos-base:latest
docker build -t 127.0.0.1:9900/centos-base:latest .
docker run  -it -d --name centos-base-1 --rm 127.0.0.1:9900/centos-base:latest
docker exec -it centos-base-1 bash 
docker push 127.0.0.1:9900/centos-base:latest


