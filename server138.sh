#!/bin/bash
##############
cd /iflytek/server
jps|awk '{print $2}' > running138.txt
key1=`cat running138.txt|awk '{if($1=="activemq.jar") print $1}'`
if [ -z $key1 ]
then
	cd /iflytek/server/apache-activemq-5.9.0/bin
	./activemq start
fi

#Before start esql,need start zk,zkui,es
ssh -Tq 12.27.1.139 <<EOF
cd /iflytek/server
jps|awk '{print $2}' > running139.txt
key1=`cat running139.txt|awk '{if($1=="QuorumPeerMain") print $1}'`
if [ -z $key1 ]
then
	cd /iflytek/server/zookeeper/bin
	./zkServer.sh start
fi
cd /iflytek/server
ps aux|grep fdfs_trackerd|awk '{print $11}'|awk -F "/" '{print $2}' >> running139.txt
key2=`cat running139.txt|awk '{if($1=="fdfs_trackerd") print $1}'`
if [ -z $key2 ]
then
	cd /iflytek/server/fastdfs/tracker
	./fdfs_trackerd ../conf/tracker.conf
	cd /iflytek/server/fastdfs/storage
	./fdfs_storaged ../conf/storage.conf
fi
exit
EOF


ssh -Tq 12.27.1.140 <<EOF
cd /iflytek/server
jps|awk '{print $2}' > running140.txt
key1=`cat running140.txt|awk '{if($1=="QuorumPeerMain") print $1}'`
if [ -z $key1 ]
then
	cd /iflytek/server/zookeeper/bin
	./zkServer.sh start
fi

cd /iflytek/server
ps aux|grep fdfs_trackerd|awk '{print $11}'|awk -F "/" '{print $2}' >> running140.txt
key2=`cat running140.txt|awk '{if($1=="fdfs_trackerd") print $1}'`
if [ -z $key2 ]
then
	cd /iflytek/server/fastdfs/tracker
	./fdfs_trackerd ../conf/tracker.conf
	cd /iflytek/server/fastdfs/storage
	./fdfs_storaged ../conf/storage.conf
fi
exit
EOF

ssh -Tq 12.27.1.141 <<EOF
cd /iflytek/server
jps|awk '{print $2}' > running140.txt
key1=`cat running140.txt|awk '{if($1=="QuorumPeerMain") print $1}'`
if [ -z $key1 ]
then
	cd /iflytek/server/zookeeper/bin
	./zkServer.sh start
fi

cd /iflytek/server
ps aux|grep fdfs_trackerd|awk '{print $11}'|awk -F "/" '{print $2}' >> running141.txt
key2=`cat running141.txt|awk '{if($1=="fdfs_trackerd") print $1}'`
if [ -z $key2 ]
then
	cd /iflytek/server/fastdfs/tracker
	./fdfs_trackerd ../conf/tracker.conf
	cd /iflytek/server/fastdfs/storage
	./fdfs_storaged ../conf/storage.conf
fi
exit
EOF

cd /iflytek/server
jps|awk '{print $2}' > running138.txt
key2=`cat running138.txt|awk '{if($1=="zkui") print $1}'`
if [ -z $key2 ]
then
	cd /iflytek/server/zkui2.0
	./start.sh
fi

#connect to the server to start es
ssh -Tq 12.27.1.142 <<EOF
cd /iflytek/server
jps|awk '{print $2}' > running142.txt
key=`cat running142.txt|awk '{if($1=="WrapperSimpleApp") print $1}'`
if [ -z $key ]
then
	cd /iflytek/server/elasticsearch-1.5.1/bin/service
	sh elasticsearch start
fi
exit
EOF

#connect to the server to start es
ssh -Tq 12.27.1.143 <<EOF
cd /iflytek/server
jps|awk '{print $2}' > running143.txt
key=`cat running143.txt|awk '{if($1=="WrapperSimpleApp") print $1}'`
if [ -z $key ]
then
	cd /iflytek/server/elasticsearch-1.5.1/bin/service
	sh elasticsearch start
fi
exit
EOF


#connect to the server to start es
ssh -Tq 12.27.1.144 <<EOF
cd /iflytek/server
jps|awk '{print $2}' > running144.txt
key=`cat running144.txt|awk '{if($1=="WrapperSimpleApp") print $1}'`
if [ -z $key ]
then
	cd /iflytek/server/elasticsearch-1.5.1/bin/service
	sh elasticsearch start
fi
exit
EOF


#connect to the server to start es
ssh -Tq 12.27.1.145 <<EOF
cd /iflytek/server
jps|awk '{print $2}' > running145.txt
key=`cat running145.txt|awk '{if($1=="WrapperSimpleApp") print $1}'`
if [ -z $key ]
then
	cd /iflytek/server/elasticsearch-1.5.1/bin/service
	sh elasticsearch start
fi
exit
EOF


#connect to the server to start es
ssh -Tq 12.27.1.146 <<EOF
cd /iflytek/server
jps|awk '{print $2}' > running146.txt
key=`cat running146.txt|awk '{if($1=="WrapperSimpleApp") print $1}'`
if [ -z $key ]
then
	cd /iflytek/server/elasticsearch-1.5.1/bin/service
	sh elasticsearch start
fi
exit
EOF


#connect to the server to start es
ssh -Tq 12.27.1.147 <<EOF
cd /iflytek/server
jps|awk '{print $2}' > running147.txt
key=`cat running147.txt|awk '{if($1=="WrapperSimpleApp") print $1}'`
if [ -z $key ]
then
	cd /iflytek/server/elasticsearch-1.5.1/bin/service
	sh elasticsearch start
fi
exit
EOF


#connect to the server to start es
ssh -Tq 12.27.1.148 <<EOF
cd /iflytek/server
jps|awk '{print $2}' > running148.txt
key=`cat running148.txt|awk '{if($1=="WrapperSimpleApp") print $1}'`
if [ -z $key ]
then
	cd /iflytek/server/elasticsearch-1.5.1/bin/service
	sh elasticsearch start
fi
exit
EOF


#connect to the server to start es
ssh -Tq 12.27.1.149 <<EOF
cd /iflytek/server
jps|awk '{print $2}' > running149.txt
key=`cat running149.txt|awk '{if($1=="WrapperSimpleApp") print $1}'`
if [ -z $key ]
then
	cd /iflytek/server/elasticsearch-1.5.1/bin/service
	sh elasticsearch start
fi
exit
EOF


#connect to the server to start es
ssh -Tq 12.27.1.150 <<EOF
cd /iflytek/server
jps|awk '{print $2}' > running150.txt
key=`cat running150.txt|awk '{if($1=="WrapperSimpleApp") print $1}'`
if [ -z $key ]
then
	cd /iflytek/server/elasticsearch-1.5.1/bin/service
	sh elasticsearch start
fi
exit
EOF


#connect to the server to start es
ssh -Tq 12.27.1.151 <<EOF
cd /iflytek/server
jps|awk '{print $2}' > running151.txt
key=`cat running151.txt|awk '{if($1=="WrapperSimpleApp") print $1}'`
if [ -z $key ]
then
	cd /iflytek/server/elasticsearch-1.5.1/bin/service
	sh elasticsearch start
fi
exit
EOF


#connect to the server to start es
ssh -Tq 12.27.1.152 <<EOF
cd /iflytek/server
jps|awk '{print $2}' > running152.txt
key=`cat running152.txt|awk '{if($1=="WrapperSimpleApp") print $1}'`
if [ -z $key ]
then
	cd /iflytek/server/elasticsearch-1.5.1/bin/service
	sh elasticsearch start
fi
exit
EOF


#connect to the server to start es
ssh -Tq 12.27.1.153 <<EOF
cd /iflytek/server
jps|awk '{print $2}' > running153.txt
key=`cat running153.txt|awk '{if($1=="WrapperSimpleApp") print $1}'`
if [ -z $key ]
then
	cd /iflytek/server/elasticsearch-1.5.1/bin/service
	sh elasticsearch start
fi
exit
EOF


#connect to the server to start es
ssh -Tq 12.27.1.154 <<EOF
cd /iflytek/server
jps|awk '{print $2}' > running154.txt
key=`cat running154.txt|awk '{if($1=="WrapperSimpleApp") print $1}'`
if [ -z $key ]
then
	cd /iflytek/server/elasticsearch-1.5.1/bin/service
	sh elasticsearch start
fi
exit
EOF


#connect to the server to start es
ssh -Tq 12.27.1.205 <<EOF
cd /iflytek/server
jps|awk '{print $2}' > running205.txt
key=`cat running205.txt|awk '{if($1=="WrapperSimpleApp") print $1}'`
if [ -z $key ]
then
	cd /iflytek/server/elasticsearch-1.5.1/bin/service
	sh elasticsearch start
fi
exit
EOF


#connect to the server to start es
ssh -Tq 12.27.1.206 <<EOF
cd /iflytek/server
jps|awk '{print $2}' > running206.txt
key=`cat running206.txt|awk '{if($1=="WrapperSimpleApp") print $1}'`
if [ -z $key ]
then
	cd /iflytek/server/elasticsearch-1.5.1/bin/service
	sh elasticsearch start
fi
exit
EOF


#connect to the server to start es
ssh -Tq 12.27.1.207 <<EOF
cd /iflytek/server
jps|awk '{print $2}' > running207.txt
key=`cat running207.txt|awk '{if($1=="WrapperSimpleApp") print $1}'`
if [ -z $key ]
then
	cd /iflytek/server/elasticsearch-1.5.1/bin/service
	sh elasticsearch start
fi
exit
EOF

#If the esql is not running,start it
cd /iflytek/server
jps|awk '{print $2}' >> running138.txt
key3=`cat running138.txt|awk '{if($1=="elasticsql.jar") print $1}'`
if [ -z $key3 ]
then
	cd /iflytek/server/elasticsql
	nohup ./start.sh &
fi

#connect to 139 server to start ispp-dfs
ssh -Tq 12.27.1.139 <<EOF
cd /iflytek/server
jps|awk '{print $2}' >> running139.txt
keys=`cat running139.txt|awk '{if($1=="ispp-dfs.jar") print $1}'`
if [ -z $key3 ]
then
	cd /iflytek/server/ispp-dfs
	./start.sh
fi
exit
EOF

#connect to 140 server to start ispp-dfs
ssh -Tq 12.27.1.140 <<EOF
cd /iflytek/server
jps|awk '{print $2}' >> running140.txt
keys=`cat running140.txt|awk '{if($1=="ispp-dfs.jar") print $1}'`
if [ -z $key3 ]
then
	cd /iflytek/server/ispp-dfs
	./start.sh
fi
exit
EOF

#connect to 141 server to start ispp-dfs
ssh -Tq 12.27.1.141 <<EOF
cd /iflytek/server
jps|awk '{print $2}' >> running141.txt
keys=`cat running141.txt|awk '{if($1=="ispp-dfs.jar") print $1}'`
if [ -z $key3 ]
then
	cd /iflytek/server/ispp-dfs
	./start.sh
fi
exit
EOF
