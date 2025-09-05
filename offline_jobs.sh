#!/bin/sh
PREFIX="offline_jobs [%Y-%m-%d %H:%M:%.S]"
LOG_FILE=/var/log/offline_jobs.log
set -a; source /etc/environment; set +a;
echo "Starting..." | ts "${PREFIX}" >> $LOG_FILE
su -s /bin/sh -c 'cd /var/www/html/pages/tools && nice -n 19 ionice -c2 -n7 php offline_jobs.php' apache 2>&1 | ts "${PREFIX}" >> $LOG_FILE
