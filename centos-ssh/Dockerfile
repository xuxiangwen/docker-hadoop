# "ported" by Adam Miller <maxamillion@fedoraproject.org> from
#   https://github.com/fedora-cloud/Fedora-Dockerfiles
#
# Originally written for Fedora-Dockerfiles by
#   scollier <scollier@redhat.com>

FROM centos:centos7
MAINTAINER The CentOS Project <cloud-ops@centos.org>

RUN http_proxy=http://web-proxy.rose.hp.com:8080 \
&& echo proxy=$http_proxy | tee -a /etc/yum.conf 
RUN yum -y update; yum clean all
RUN yum -y install openssh openssh-clients  openssh-server passwd; yum clean all
ADD ./start.sh /start.sh
RUN mkdir /var/run/sshd

RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' 

RUN chmod 755 /start.sh
# EXPOSE 22
RUN ./start.sh
#RUN /usr/sbin/sshd 

#RUN /usr/sbin/sshd
ENTRYPOINT ["/usr/sbin/sshd", "-D"]
#CMD ["/bin/bash"]
#CMD ["tail", "-f", "/dev/null"]
