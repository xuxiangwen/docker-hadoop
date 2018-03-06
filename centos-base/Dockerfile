FROM centos:7

RUN http_proxy=http://web-proxy.rose.hp.com:8080 \
&& echo proxy=$http_proxy | tee -a /etc/yum.conf \
&& yum install -y epel-release \
&& yum install -y sudo openssh openssh-server passwd wget git which  pdsh \ 
&& yum clean all \
&& echo http_proxy=$http_proxy | sudo tee -a /etc/wgetrc \  
&& echo https_proxy=$https_proxy | sudo tee -a /etc/wgetrc \
&& echo 'grid    ALL=(ALL)       NOPASSWD: ALL' | tee -a /etc/sudoers \
&& user=grid   \
&& useradd $user \
&& SSH_USERPASS=grid \
&& echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --stdin $user) \
&& echo ssh $user password: $SSH_USERPASS \
&& mkdir /var/run/sshd \
&& ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' 
 
CMD ["/usr/sbin/sshd", "-D"]
