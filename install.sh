#!/bin/bash
######
set -e
src_pkt=/isoft/install
#rpm -e --nodeps `rpm -qa|grep -i mysql`
rpm -e --nodeps `rpm -qa|grep -i mariadb`
rpm -ivh xz-devel.rpm
rpm -ivh zlib-devel-1.2.7.rpm

#Install mysql
cd ${src_pkt}
rpm -ivh mysql-server.rpm
rpm -ivh mysql-devel.rpm
rpm -ivh mysql-client.rpm
sleep 3

#Install the source package of apr
cd ${src_pkt}
tar xf apr-1.5.2.tar.gz
cd apr-1.5.2
./configure --prefix=/usr/local/apr
make && make install
sleep 3

#Install the source package of apr-util
cd ${src_pkt}
tar zxf apr-util-1.5.2.tar.gz
cd apr-util-1.5.2
./configure --prefix=/usr/local/apr-util --with-apr=/usr/local/apr
make clean
make && make install
sleep 3

#Install the source package of pcre
cd ${src_pkt}
tar zxf pcre-8.39.tar.gz
cd pcre-8.39
./configure --prefix=/usr/local/pcre
make && make install
sleep 3

#Install apache-httpd
cd ${src_pkt}
tar zxf httpd-2.4.20.tar.gz
cd httpd-2.4.20
./configure --prefix=/usr/local/apache --with-apr=/usr/local/apr --with-apr-util=/usr/local/apr-util --with-pcre=/usr/local/pcre
make && make install
cd /usr/local/apache/conf
sed -i '190a ServerName 127.0.0.1:80' httpd.conf
sleep 3

#Install the source package of libxml2
#cd ${src_pkt}
#tar zxf libxml2-2.7.8.tar.gz
#cd libxml2-2.7.8
#./configure --prefix=/usr/local/libxml2
#make && make install
#sleep 3

#Install php5
cd ${src_pkt}
tar zxf php-5.6.25.tar.gz
cd php-5.6.25
./configure --prefix=/usr/local/php  --with-apxs2=/usr/local/apache/bin/apxs --with-mysqli --with-pdo-mysql --enable-mbstring
make && make install

#Configure the php
cp php.ini-production /usr/local/lib/php.ini

#Install jdk
cd ${src_pkt}
tar zxf jdk-7u76-linux-x64.tar.gz -C /usr/local
cd /usr/local
mv jdk1.7.0_76 java7
echo "export JAVA_HOEM=/usr/local/java7" >> /etc/profile
echo "export PATH=/usr/local/java7/bin:$PATH" >> /etc/profile
echo "export CLASSPATH=.:/usr/local/java7/lib/dt.jar:/usr/local/java7/lib/tools.jar" >> /etc/profile
source /etc/profile
