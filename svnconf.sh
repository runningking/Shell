#!/bin/bash
#backup_dir=/isoft/backup/svnconf
backup_dir=/usr/local/backup/svnconf
log_dir=/isoft/scripts/logs
s_dir=/usr/local/svnconfig

if [ ! -f ${log_dir}/svn_backup.log ]
then
	touch ${log_dir}/svn_backup.log
fi

#Backup the config file of svn
cp ${s_dir}/passwd ${backup_dir}/passwd.`date +%Y%m%d`
cp ${s_dir}/authz ${backup_dir}/authz.`date +%Y%m%d`
echo $(date +"%Y-%m-%d %H:%M:%S") "passwd backup successed..." >> ${log_dir}/svn_backup.log
echo $(date +"%Y-%m-%d %H:%M:%S") "authz backup successed..." >> ${log_dir}/svn_backup.log
echo "==========================================" >> ${log_dir}/svn_backup.log
rm -fr /usr/local/backup/svnconf/passwd.`date -d -2days +%Y%m%d`
rm -fr /usr/local/backup/svnconf/authz.`date -d -2days +%Y%m%d`
