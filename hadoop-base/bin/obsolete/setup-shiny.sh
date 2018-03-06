
#!/bin/sh
server=c9t0[8872,8874,8875,8876].itcs.hp.com
nginxserver=c9t08876.itcs.hp.com
shinyserver=c9t088[72,74,75].itcs.hp.com
#c9t07959.itcs.hp.com
#c9t08876.itcs.hp.com
#c9t07959.itcs.hp.com
#c9t088[72,74,75,76].itcs.hp.com
sourcepath=/home/poc/cluster/cluster-install
user=poc
copypath=/home/poc
targetpath=$copypath/cluster-install
aapath=/opt/mount1/aa

#if [[ "$server" = "" ]]; then
# echo please input servers that are deployed
# exit 1
#fi

#echo ----------connect without password----------
#ssh-copy-id -i ~/.ssh/id_rsa.pub  poc@localhost
#ssh-copy-id -i ~/.ssh/id_rsa.pub  poc@c9t08876.itcs.hp.com
#ssh-copy-id -i ~/.ssh/id_rsa.pub  poc@c9t08875.itcs.hp.com
#ssh-copy-id -i ~/.ssh/id_rsa.pub  poc@c9t08874.itcs.hp.com
#ssh-copy-id -i ~/.ssh/id_rsa.pub  poc@c9t08872.itcs.hp.com
#pdcp -w ssh:poc@c9t08873.itcs.hp.com ~/.ssh/authorized_keys ~/.ssh/

echo ----------copy cluster install----------
pdsh -w ssh:$user@$server rm -rf $targetpath
pdcp -w ssh:$user@$server -r $sourcepath $copypath
pdcp -w ssh:$user@$server ~/.ssh/authorized_keys ~/.ssh/
pdcp -w ssh:$user@$server ~/.ssh/known_hosts ~/.ssh/

echo
echo ----------shiny install----------
pdsh -w ssh:$user@$shinyserver $targetpath/shiny/shiny-install.sh

echo
echo ----------shiny configuration----------
shinypath=$aapath/shinyapp
entrance=pdms
project1=pwax

pdsh -w ssh:$user@$shinyserver sudo mkdir $aapath
pdsh -w ssh:$user@$shinyserver sudo chown -R $user:$user $aapath
pdsh -w ssh:$user@$shinyserver rm -rf $shinypath
pdsh -w ssh:$user@$shinyserver mkdir $shinypath

pdcp -w ssh:$user@$shinyserver -r $aapath/common $aapath
pdcp -w ssh:$user@$shinyserver -r $shinypath/$entrance $shinypath
pdcp -w ssh:$user@$shinyserver -r $shinypath/$project1 $shinypath

pdsh -w ssh:$user@$shinyserver mkdir $shinypath/sites
pdsh -w ssh:$user@$shinyserver ln -s $shinypath $shinypath/sites/site1
pdsh -w ssh:$user@$shinyserver ln -s $shinypath $shinypath/sites/site2
pdsh -w ssh:$user@$shinyserver ln -s $shinypath $shinypath/sites/site3
pdsh -w ssh:$user@$shinyserver ln -s $shinypath $shinypath/sites/site4

pdsh -w ssh:$user@$shinyserver sudo rm -rf /srv/shiny-server/$entrance
pdsh -w ssh:$user@$shinyserver sudo rm -rf /srv/shiny-server/sites
pdsh -w ssh:$user@$shinyserver sudo ln -s $shinypath/$entrance /srv/shiny-server/$entrance
pdsh -w ssh:$user@$shinyserver sudo ln -s $shinypath/sites /srv/shiny-server/sites

echo
echo ----------install r library used by shiny app----------
pdsh -w ssh:$user@$shinyserver sudo $targetpath/install.packages.sh shiny
pdsh -w ssh:$user@$shinyserver sudo $targetpath/install.packages.sh shinydashboard
pdsh -w ssh:$user@$shinyserver sudo $targetpath/install.packages.sh ggplot2
pdsh -w ssh:$user@$shinyserver sudo $targetpath/install.packages.sh latticeExtra
pdsh -w ssh:$user@$shinyserver sudo $targetpath/install.packages.sh caret
pdsh -w ssh:$user@$shinyserver sudo $targetpath/install.packages.sh sqldf
pdsh -w ssh:$user@$shinyserver sudo $targetpath/install.packages.sh rJava
pdsh -w ssh:$user@$shinyserver sudo $targetpath/instals.sh RJDBC
pdsh -w ssh:$user@$shinyserver sudo $targetpath/install.packages.sh corrplot
pdsh -w ssh:$user@$shinyserver sudo $targetpath/install.packages.sh stringi
pdsh -w ssh:$user@$shinyserver sudo $targetpath/install.packages.sh fpc
pdsh -w ssh:$user@$shinyserver sudo $targetpath/install.packages.sh xlsx
pdsh -w ssh:$user@$shinyserver sudo $targetpath/install.packages.sh reshape
pdsh -w ssh:$user@$shinyserver sudo $targetpath/install.packages.sh dplyr

echo
echo ----------install shiny app update----------
#must run on the rstuio server(c9t07959.itcs.hp.com)
#ssh-copy-id -i ~/.ssh/id_rsa.pub  poc@c9t08876.itcs.hp.com
pdcp -w ssh:$user@$nginxserver $shinypath/pwax $shinypath
pdcp -w ssh:$user@$shinyserver $shinypath/pwax $shinypath


echo
echo ----------Nginx Install----------
pdsh -w ssh:$user@$nginxserver sudo yum install -y nginx 
#sudo vim $targetpath/nginx/nginx.conf
#    upstream shiny_server {
#        ip_hash;
#        server c9t08872.itcs.hp.com:3838;
#        server c9t08873.itcs.hp.com:3838;
#        server c9t08874.itcs.hp.com:3838;
#        server c9t08875.itcs.hp.com:3838;
#    }
#sudo vim $targetpath/nginx/default.conf
#    location / {
#        proxy_pass      http://shiny_server;
#        proxy_set_header  X-Real-IP  $remote_addr; #加上这一行
#    }
pdsh -w ssh:$user@$nginxserver sudo cp $targetpath/nginx/nginx.conf /etc/nginx
pdsh -w ssh:$user@$nginxserver sudo cp $targetpath/nginx/default.conf /etc/nginx/conf.d
pdsh -w ssh:$user@$nginxserver sudo /etc/init.d/nginx restart

echo
echo ----------Disable Fire----------
pdsh -w ssh:$user@$server sudo $targetpath/disablefire.sh
