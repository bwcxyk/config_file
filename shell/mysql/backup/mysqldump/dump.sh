#!/bin/bash
## auth dump
set -e
#set -x
databak_dir="/databasebak/yfbidata"
date=$(date +%Y%m%d%H%M)
mysqldump yfbi | gzip > ${databak_dir}/yfbi_bak_${date}.sql.gz
