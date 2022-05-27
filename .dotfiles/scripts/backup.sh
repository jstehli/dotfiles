#!/bin/bash

# backup script that generates daily / weekly / monthly backups
# this checks if the backup location is available, i.e., you can 
# use this with an external disk.
# put this in /etc/cron.hourly
# make shure to remove the ".sh" in the filename or it won't be executed
# author: Jonas Stehli


# set some global variables - edit the mountpoint according to your needs
BACKUP_MOUNTPOINT="/run/media/jonas/js-backup"
NOW=`date +"%s"`
DATE_STR=`date "+%Y-%m-%d %H:%M:%S"`
LOGDIR=$BACKUP_MOUNTPOINT"/logs"
TIMES=$LOGDIR"/times.txt"
LOGFILE=$LOGDIR"/log.txt"

# helper functions
update_times() {
    rm -f $TIMES
    touch $TIMES
    local time_array=($@)
    for time in "${time_array[@]}"; do
        echo $time >> $TIMES
    done
}

backup_command() {
    local target_dir=$1
    rsync -aAXHq --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/.snapshots/*","/home/jonas/Dropbox/*"} / $target_dir
}

# check that disk is mounted and make logdir / logfile
if [ ! -d "$BACKUP_MOUNTPOINT" ]; then
    exit 1
fi
mkdir -p $LOGDIR
touch $LOGFILE

# read the last times backup was done
do_daily=false
do_weekly=false
do_monthly=false
if [ -f $TIMES ]; then
    readarray -t backup_times < $TIMES
    if [[ $(expr $NOW - ${backup_times[0]}) -gt 86400 ]]; then
        do_daily=true
    fi
    if [[ $(expr $NOW - ${backup_times[1]}) -gt 604800 ]]; then
        do_weekly=true
    fi
    if [[ $(expr $NOW - ${backup_times[2]}) -gt 5292000 ]]; then
        do_monthly=true
    fi
else
    backup_times=(0 0 0)
    do_daily=true
    do_weekly=true
    do_monthly=true
fi

if $do_daily; then
    backup_directory=$BACKUP_MOUNTPOINT"/daily"
    mkdir -p $backup_directory
    backup_command $backup_directory
    backup_times[0]=$NOW
    update_times "${backup_times[@]}"
    echo "Daily backup done: $DATE_STR" >> $LOGFILE
fi

if $do_weekly; then
    backup_directory=$BACKUP_MOUNTPOINT"/weekly"
    mkdir -p $backup_directory
    backup_command $backup_directory
    backup_times[1]=$NOW
    update_times "${backup_times[@]}"
    echo "Weekly backup done: $DATE_STR" >> $LOGFILE
fi

if $do_monthly; then
    backup_directory=$BACKUP_MOUNTPOINT"/monthly"
    mkdir -p $backup_directory
    backup_command $backup_directory
    backup_times[2]=$NOW
    update_times "${backup_times[@]}"
    echo "Monthly backup done: $DATE_STR" >> $LOGFILE
fi


exit 0
