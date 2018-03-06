FROM centos/systemd

MAINTAINER "eipi10" <eipi10@qq.com>

RUN http_proxy=http://web-proxy.rose.hp.com:8080 \
&& echo proxy=$http_proxy | tee -a /etc/yum.conf \
&& yum -y install httpd; yum clean all; systemctl enable httpd.service

EXPOSE 80

CMD ["/usr/sbin/init"]

