#!/bin/bash
pwd="123456"
user="root"
host="192.168.1.220"
mysql_status=`mysqladmin -u${user} -p${pwd} -h${host} ping 2>/dev/null|grep alive -c`
if [ ${mysql_status} -eq "1" ]
then
	echo "yes"
    	exit 0
else
	echo "no"
	exit 1
fi
