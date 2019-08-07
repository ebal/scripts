#!/bin/sh
# ebal, Wed, 07 Aug 2019 09:10:11 +0300

# Declare Variables
HOST=$(hostname)
YEAR=$(date +%Y)
MNTH=$(date +%m)
TDAY=$(date +%d)
HHMM=$(date +%H%M)

# Create Rclone Log Directory
mkdir -p /var/log/rclone/$YEAR/$MNTH/$TDAY/

# Compress previous log file
gzip /var/log/rclone/$YEAR/$MNTH/$TDAY/*

# Define current log file
log_file="/var/log/rclone/$YEAR/$MNTH/$TDAY/$HOST-$YEAR$MNTH$TDAY$HHMM.log"

# Filter out - exclude dirs & files that we do not need
filter_f="/root/.config/rclone/filter-file.txt"

# Sync !
/usr/local/bin/rclone       \
    --quiet                 \
    --delete-before         \
    --ignore-existing       \
    --links                 \
    --filter-from $filter_f \
    --log-file $log_file    \
    sync / encrypt:/$HOST`

