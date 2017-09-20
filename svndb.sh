#!/bin/bash
##Create the svndb backup log
svndb_log=/isoft/scripts/logs
if [ ! -d ${svndb_log} ]
then
	mkdir -p  /isoft/scripts/logs
fi

##Create the backup path
#backup_db=/isoft/backup/svndb
backup_db=/usr/local/backup/svndb
if [ ! -d ${backup_db} ]
then
	mkdir -p /usr/local/backup/svndb
fi

#Appoint the source path of svn db
source_svn=/usr/local/svn

##Get the backup time
date=`date +%Y%m%d`

##Begin to backup the svn db
cd /usr/local/svn
for name in $(ls)
do
	svnadmin hotcopy ${source_svn}/${name} ${backup_db}/${name}.${date}
	echo $(date +"%Y-%m-%d") ${name} "backup successed.." >> ${svndb_log}/svndb_backup.log
	rm -fr /usr/local/backup/svndb/${name}.`date -d -1days +%Y%m%d`.tar.gz
done

#Compress the svndb
cd /usr/local/backup/svndb
for name in $(ls)
do
	tar czf ${name}.tar.gz ${name}
	rm -fr ${name}
done
