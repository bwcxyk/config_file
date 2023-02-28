#!/bin/bash
## auth dump
set -e
#set -x

db="yfbi"
backup_dir="/data/backup/db_backup/${db}"

date=$(date +%Y%m%d%H%M)
mysqldump ${db} | gzip > ${backup_dir}/${db}_${date}.sql.gz