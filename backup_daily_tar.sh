#!/bin/bash
##Backup the upload file fully
srcdir=/shares/sdcmp
logfile=/shares/sdcmp/backupdaily.log
date=`date +%Y%m%d`

#create the log file
if [ ! -f "$logfile" ]
then
	cd $srcdir
	touch backupdaily.log
fi

#enter the backup path
cd $srcdir
#backup the upload dir fully
tar -g snapshot -zcf upload_${date}.tar.gz upload
echo $(date "+%Y-%m-%d:") ": file backup daily success" > $logfile
