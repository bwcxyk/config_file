#!/bin/bash
if [ -f /.backTemp ];then
  source /.backTemp
fi

if [ ! -d $HAS_FALL_BACK ]; then
  echo "未全量备份，跳过本次增量备份"
  exit 0
fi

# docker需要判断环境变量文件是否存在
if [ -f /dockerenv ];then
  source /dockerenv
  env
fi

INNOBACKUPEXFULL=/usr/bin/innobackupex
TODAY=`date +%Y%m%d%H%M`
YESTERDAY=`date -d"yesterday" +%Y%m%d%H%M`
FULLBACKUPDIR=$BASE_DIR/full # 全库备份的目录
INCRBACKUPDIR=$BASE_DIR/incr # 增量备份的目录
TMPFILEDIR=$BASE_DIR/logs # 日志目录
TMPFILE="$TMPFILEDIR/innobackup_$TODAY.$$.log" # 日志文件

#############################################################################
# 打印错误信息并退出
#############################################################################
error()
{
    echo "$1" 1>&2
    exit 1
}
 
# 开始备份前检查相关的参数
if [ ! -x $INNOBACKUPEXFULL ]; then
  error "$INNOBACKUPEXFULL does not exist."
fi
 
#if [ ! -d $BASE_DIR ]; then
#  error "Backup destination folder: $BASE_DIR does not exist."
#fi
 
# 输出备份信息
echo "----------------------------"
echo
echo "$0: MySQL backup script"
echo "started: `date '+%Y-%m-%d %H:%M:%S'`"
echo "exec $INNOBACKUPEXFULL $OPTION $FULLBACKUPDIR > $TMPFILE 2>&1"
echo
 
# 如果备份目录不存在则创建相应的全备增备目录
for i in $FULLBACKUPDIR $INCRBACKUPDIR $TMPFILEDIR; do
  if [ ! -d $i ]; then
    mkdir -pv $i
  fi
done
 
# 查找最近的全备目录
LATEST_FULL=`find $FULLBACKUPDIR -mindepth 1 -maxdepth 1 -type d -printf "%P\n"`
echo "最近的全备目录为: $LATEST_FULL" 

# 如果最近的全备仍然可用执行增量备份
# 创建增量备份的目录
TMPINCRDIR=$INCRBACKUPDIR/$LATEST_FULL
mkdir -p $TMPINCRDIR
BACKTYPE="incr"
# 获取最近的增量备份目录
LATEST_INCR=`find $TMPINCRDIR -mindepth 1 -maxdepth 1 -type d | sort -nr | head -1`
echo "最近的增量备份目录为: $LATEST_INCR"
# 如果是首次增量备份，那么basedir则选择全备目录，否则选择最近一次的增量备份目录
if [ ! $LATEST_INCR ] ; then
  INCRBASEDIR=$FULLBACKUPDIR/$LATEST_FULL
else
  INCRBASEDIR=$LATEST_INCR
fi
echo "Running new incremental backup using $INCRBASEDIR as base."
echo "start exec $INNOBACKUPEXFULL $OPTION --incremental $TMPINCRDIR --incremental-basedir $INCRBASEDIR > $TMPFILE 2>&1"
$INNOBACKUPEXFULL $OPTION --incremental $TMPINCRDIR --incremental-basedir $INCRBASEDIR > $TMPFILE 2>&1

 
if [ -z "`tail -1 $TMPFILE | grep 'completed OK!'`" ] ; then
 echo "$INNOBACKUPEX failed:"; echo
 echo "---------- ERROR OUTPUT from $INNOBACKUPEX ----------"
 exit 1
fi

# 这里获取这次备份的目录 
THISBACKUP=`awk -- "/Backup created in directory/ { split( \\\$0, p, \"'\" ) ; print p[2] }" $TMPFILE`
echo "THISBACKUP=$THISBACKUP"
echo
echo "Databases backed up successfully to: $THISBACKUP"

echo
echo "incremental completed: `date '+%Y-%m-%d %H:%M:%S'`"
exit 0