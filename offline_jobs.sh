#!/bin/sh
LOG_FILE=/var/log/offline_jobs.log
set -a; source /etc/environment; set +a;
date >> $LOG_FILE
echo "offline_jobs" >> $LOG_FILE
su -s /bin/sh -c 'cd /var/www/html/pages/tools && nice -n 19 ionice -c2 -n7 php offline_jobs.php' apache >> $LOG_FILE 2>&1
