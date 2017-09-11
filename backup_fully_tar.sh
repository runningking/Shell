#!/bin/bash
##Backup the upload file fully
srcdir=/shares/sdcmp
logfile=/shares/sdcmp/backupfully.log

#create the log file
if [ ! -f "$logfile" ]
then
	cd $srcdir
	touch backupfully.log
fi

#enter the backup path
cd $srcdir
#backup the upload dir fully
tar -g snapshot -zcf upload.tar.gz upload
echo $(date "+%Y-%m-%d:") ": file backup fully success" > $logfile
