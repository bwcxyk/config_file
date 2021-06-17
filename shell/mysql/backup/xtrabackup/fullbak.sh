#!/bin/bash
echo "export HAS_FALL_BACK=" > /.backTemp

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
echo
 
# 如果备份目录不存在则创建相应的全备增备目录
for i in $FULLBACKUPDIR $INCRBACKUPDIR $TMPFILEDIR; do
  if [ ! -d $i ]; then
    mkdir -pv $i
  fi
done
 
# 压缩上传前一天的备份
echo "压缩前一天的备份"
cd $BASE_DIR
tar -zcf $YESTERDAY.tar.gz ./full/ ./incr/
# scp -P 8022 $YESTERDAY.tar.gz root@192.168.10.46:/data/backup/mysql/
#if [ $? = 0 ]; then
rm -rf $FULLBACKUPDIR $INCRBACKUPDIR
echo "开始全量备份"
echo "start exec $INNOBACKUPEXFULL $OPTION $FULLBACKUPDIR > $TMPFILE 2>&1"
$INNOBACKUPEXFULL $OPTION $FULLBACKUPDIR > $TMPFILE 2>&1
#else
#  echo "远程备份失败"
#fi
 
if [ -z "`tail -1 $TMPFILE | grep 'completed OK!'`" ] ; then
 echo "$INNOBACKUPEXFULL failed:"; echo
 echo "---------- ERROR OUTPUT from $INNOBACKUPEXFULL ----------"
# cat $TMPFILE
# rm -f $TMPFILE
 exit 1
fi

# 这里获取这次备份的目录 
THISBACKUP=`awk -- "/Backup created in directory/ { split( \\\$0, p, \"'\" ) ; print p[2] }" $TMPFILE`
echo "THISBACKUP=$THISBACKUP"
#rm -f $TMPFILE
echo "Databases backed up successfully to: $THISBACKUP"

# Cleanup
echo "delete tar files of 10 days ago"
find $BASE_DIR/ -mtime +10 -name "*.tar.gz"  -exec rm -rf {} \;
 
echo
echo "completed: `date '+%Y-%m-%d %H:%M:%S'`"
echo "export HAS_FALL_BACK=true" > /.backTemp
exit 0