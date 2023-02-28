#!/bin/bash

set -ex

source /etc/profile
date=$(date +%Y%m%d%H%M)
pg_user=user
dbname=price_center
schema=task
backup_dir="/data/backup/${dbname}"

pg_dump -U ${pg_user} -d ${dbname} -n ${schema} -Fc -f ${backup_dir}/${schema}_${date}.dump