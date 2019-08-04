#!/bin/sh
# ebal, Sun, 04 Aug 2019 16:33:14 +0300

# Create Rclone Log Directory
mkdir -p  /var/log/rclone/`date +%Y`/`date +%m`/`date +%d`/

# Compress previous log file
gzip /var/log/rclone/`date +%Y`/`date +%m`/`date +%d`/*

# Define current log file
log_file="/var/log/rclone/`date +%Y`/`date +%m`/`date +%d`/`hostname -f`-`date +%Y%m%d_%H%M`.log"

# Filter out - exclude dirs & files that we do not need
filter_f="/root/.config/rclone/filter-file.txt"

# Sync !
/usr/local/bin/rclone
    --quiet
    --delete-before
    --ignore-existing
    --links
    --filter-from $filter_f
    --log-file $log_file
    sync / encrypt:/`hostname -f`/

