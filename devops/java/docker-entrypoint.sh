#!/bin/bash
set -e

echo "0 0 * * * find /tmp/eprint -mindepth 2 -type d -mtime +1 -print0 | xargs -0 rm -rfv" > /var/spool/cron/crontabs/root
/usr/sbin/crond

exec "$@"
