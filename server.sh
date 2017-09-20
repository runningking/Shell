#!/bin/bash

set -e

log_dir=/isoft/scripts/logs

#if the log file is not exist,create it
if [ ! -f ${log_dir}/run.log ]
then
	touch ${log_dir}/run.log
fi
	
#Estimate the vpn is running or not.if vpn is not running ,restart it.
ps aux | awk '{print $11}' > running.txt
key1=`cat running.txt | awk '{if($1=="/usr/sbin/pptpd") print $1}'`
if [ -z $key1 ]
then
	service pptpd start
	echo $(date +"%y-%m-%d %H:%M:%S") ": vpn is started.." >> ${log_dir}/run.log
else
	echo $(date +"%y-%m-%d %H:%M:%S") ": vpn is running.." >> ${log_dir}/run.log

fi

#Estimate the svn is running or not.if vpn is not running,restart it.
ps aux | awk '{print $11}' >> running.txt
key2=`cat running.txt | awk '{if($1=="svnserve") print $1}'`
if [ -z ${key2} ]
then
	svnserve -d -r /usr/local/svn
	echo $(date +"%y-%m-%d %H:%M:%S") ": svn is started.." >> ${log_dir}/run.log
else
	echo $(date +"%y-%m-%d %H:%M:%S") ": svn is running.." >> ${log_dir}/run.log
fi

#Estimate the mysql is running or not.if mysql is not running,restart it.
netstat -anp | grep mysql |  awk '{print $4}'  >> running.txt
key3=`cat running.txt | awk '{if($1=="0.0.0.0:3306") print $1}'`
if [ -z $key3 ]
then
	service mysql start
	echo $(date +"%y-%m-%d %H:%M:%S") ": mysql is started.." >> ${log_dir}/run.log
else 
	echo $(date +"%y-%m-%d %H:%M:%S") ": mysql is running.." >> ${log_dir}/run.log
fi

#Estimate the zentao is running or not.if zentao is not running,restart it.
netstat -anp | grep httpd | awk '{print $4}' >> running.txt
key4=`cat running.txt | awk '{if($1=="0.0.0.0:8080") print $1}'`
if [ -z $key4 ]
then
	/opt/zbox/zbox start
	echo $(date +"%y-%m-%d %H:%M:%S") ": zentao is started.." >> ${log_dir}/run.log
else
	echo $(date +"%y-%m-%d %H:%M:%S") ": zentao is running.." >> ${log_dir}/run.log
fi

#Estimate the nginx is running or not.if nginx is not running,restart it.
netstat -anp | grep nginx | awk '{print $4}' >> running.txt
key4=`cat running.txt | awk '{if($1=="0.0.0.0:80") print $1}'`
if [ -z $key4 ]
then
	/usr/local/nginx/sbin/nginx
	echo $(date +"%y-%m-%d %H:%M:%S") ": nginx is started.." >> ${log_dir}/run.log
else
	echo $(date +"%y-%m-%d %H:%M:%S") ": nginx is running.." >> ${log_dir}/run.log
fi

#Estimate the apache is running or not.if apache is not running,restart it.
netstat -anp | grep httpd | awk '{print $4}' >> running.txt
key4=`cat running.txt | awk '{if($1=="0.0.0.0:8000") print $1}'`
if [ -z $key4 ]
then
	/usr/local/apache/bin/apachectl -k start
	echo $(date +"%y-%m-%d %H:%M:%S") ": apache is started.." >> ${log_dir}/run.log
else
	echo $(date +"%y-%m-%d %H:%M:%S") ": apache is running.." >> ${log_dir}/run.log
fi

#Estimate the nexus is running or not,if nexus is not running,restart it.
#ps aux | awk '{print $11}' >> running.txt
#key5=`cat running.txt | awk '{if($1=="/usr/local/nexus/nexus/bin/../bin/jsw/linux-x86-64/wrapper") print $1}'`
#if [ -z $key5 ]
#then
#	cd /usr/local/nexus/nexus/bin/
#	./nexus start
#	echo $(date +"%y-%m-%d %H:%M:%S") ": maven is started.." >> ${log_dir}/run.log
#else
#	echo $(date +"%y-%m-%d %H:%M:%S") ": maven is running.." >> ${log_dir}/run.log
#fi
echo "=======================================" >> ${log_dir}/run.log
