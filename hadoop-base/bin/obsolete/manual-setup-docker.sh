################################################################################
#docker 入门
# https://www.gitbook.com/book/yeasy/docker_practice/details
################################################################################

################################################################################
# Install Docker on CentOS
#   see also https://yeasy.gitbooks.io/docker_practice/content/
################################################################################

sudo yum update -y #Make sure your existing packages are up-to-date.
#Add the yum repo.
sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF
sudo yum install -y docker-engine #Install the Docker package.
sudo systemctl enable docker.service #Enable the service.
sudo systemctl start docker  #Start the Docker daemon.

#HTTP proxy
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo rm -rf /etc/systemd/system/docker.service.d/http-proxy.conf
echo "[Service]" | sudo tee -a /etc/systemd/system/docker.service.d/http-proxy.conf
echo "Environment=\"HTTP_PROXY=http://web-proxy.rose.hp.com:8080/\"  \"HTTPS_PROXY=http://web-proxy.rose.hp.com:8080/\"  \"NO_PROXY=localhost,127.0.0.1,15.15.165.35,15.15.166.231,15.15.166.234\"" | sudo tee -a /etc/systemd/system/docker.service.d/http-proxy.conf
cat /etc/systemd/system/docker.service.d/http-proxy.conf
sudo systemctl daemon-reload
# systemctl show --property=Environment docker #Verify that the configuration has been loaded:
sudo systemctl restart docker
sudo docker info

sudo docker run --rm hello-world #Verify docker is installed correctly by running a test image in a container.

################################################################################
# Create a docker group
#   The docker daemon binds to a Unix socket instead of a TCP port. By default that Unix socket is owned by the user 
#   root and other users can access it with sudo. For this reason, docker daemon always runs as the root user.
#   To avoid having to use sudo when you use the docker command, create a Unix group called docker and add users to it.
#   When the docker daemon starts, it makes the ownership of the Unix socket read/writable by the docker group.
################################################################################
sudo groupadd docker
sudo usermod -aG docker grid
#reconnect
docker run --rm hello-world

################################################################################
# Change default Image and Container location in Docker [CentOS 7]
#   http://sanenthusiast.com/change-default-image-container-location-docker/
################################################################################
sudo mkdir -p /opt/mount1/docker-data
docker info
sudo systemctl stop docker
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo rm /etc/systemd/system/docker.service.d/docker.conf
sudo touch /etc/systemd/system/docker.service.d/docker.conf
echo "[Service]" | sudo tee -a /etc/systemd/system/docker.service.d/docker.conf
echo "ExecStart=" | sudo tee -a /etc/systemd/system/docker.service.d/docker.conf
echo "ExecStart=/usr/bin/dockerd --graph=\"/opt/mount1/docker-data\" --storage-driver=devicemapper"  | sudo tee -a /etc/systemd/system/docker.service.d/docker.conf
sudo cat /etc/systemd/system/docker.service.d/docker.conf
sudo systemctl daemon-reload 
sudo systemctl start docker
docker info 

#verify
sudo du --max-depth=1 -h /opt/mount1/docker-data
docker run -t -i ubuntu /bin/bash
exit
sudo du --max-depth=1 -h /opt/mount1/docker-data

################################################################################
# Swarm
#   http://docs-stage.docker.com/engine/swarm/swarm-tutorial/
#   http://ju.outofmemory.cn/entry/293668
################################################################################
docker swarm init --advertise-addr  15.15.165.35
#docker swarm init --advertise-addr  15.15.166.234  
#docker swarm init --advertise-addr  15.15.166.231
docker swarm join-token manager #manager加入集群命令 
docker swarm join-token worker  #workder加入集群命令
docker info 

docker swarm leave --force  #manager离开集群命令 
docker swarm leave          #worker离开集群命令
sudo netstat -tulpn | grep docker 
docker node ls #查看当前Swarm节点

#防火墙
sudo firewall-cmd --permanent --zone=public --add-port=2377/tcp
sudo firewall-cmd --permanent --zone=public --add-port=7946/tcp
sudo firewall-cmd --permanent --zone=public --add-port=7946/udp
sudo firewall-cmd --permanent --zone=public --add-port=4789/tcp
sudo firewall-cmd --permanent --zone=public --add-port=4789/udp
sudo firewall-cmd --reload
sudo firewall-cmd  --list-all 

#关闭防火墙
sudo systemctl stop firewalld


#问题是为何只能加入到aa02 15.15.166.234