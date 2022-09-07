#!/bin/bash
# get the env about oracle
# must define SID and ORACLE_HOME in profile
#. ~oracle/.bash_profile

source /home/oracle/.bash_profile

# set -ex

export LOG_DIR=$HOME/awr

# ********************************
# * dba_oracle_awr.sh
# ********************************
# Usage: dba_oracle_awr.sh
#                    -d [num_days]
#                    -f [from time]
#                    -t [to time]
#                    -p [report type, html or text]
#
#                  time format: 'yyyymmddhh24'.
#                  E.g 2011030417 means 05pm, Mar 04, 2011
#                  E.g dba_oracle_awr.sh -d 7 -f 2022090100 -t 2022090700 -p html
#**********************
# get parameters
#**********************
while getopts ":d:f:t:p" opt
    do
        case $opt in
		d) day=$OPTARG
              ;;
        f) from=$OPTARG
              ;;
        t) to=$OPTARG
              ;;
        p) type=$OPTARG
              type=$(echo "${type}"|tr "[:upper:]" "[:lower:]")
              ;;
        '?') echo "$0: invalid option ?$OPTARG">&2
              exit 1
              ;;
        esac
done

if [ "$day" = "" ]
then
    echo "from day (?d} needed"
    echo "program exiting..."
    exit 1
fi
if [ "$from" = "" ]
then
    echo "from time (?f} needed"
    echo "program exiting..."
    exit 1
fi
if [ "$to" = "" ]
then
    echo "to time (?t) needed"
    echo "program exiting..."
    exit 1
fi
if [ "$type" = "" ]
then
    type="html"
fi


# ********************
# trim function
# ********************
function trim()
{
    local result
    result=$(echo "$1"|sed 's/^ *//g' | sed 's/ *$//g')
    echo "${result}"
}

#*******************************
# get begin and end snapshot ID
# *******************************
define_dur()
{
begin_id=$(
    sqlplus -s / as sysdba <<EOF 
    set pages 0
    set head off
    set feed off
    select max(SNAP_ID) from DBA_HIST_SNAPSHOT where
        END_INTERVAL_TIME<=to_date($from,'yyyymmddhh24');
EOF
)
ret_code=$?
if [ "$ret_code" != "0" ]
then
    echo "sqlplus failed with code $ret_code"
    echo "program exiting..."
    exit 10
fi
end_id=$(
    sqlplus -s / as sysdba <<EOF 
    set pages 0
    set head off
    set feed off
    select min(SNAP_ID) from DBA_HIST_SNAPSHOT where
        END_INTERVAL_TIME>=to_date($to,'yyyymmddhh24');
    spool off
EOF
)
ret_code=$?
if [ "$ret_code" != "0" ]
then
    echo "sqlplus failed with code $ret_code"
    echo "program exiting..."
    exit 10
fi
begin_id=$(trim "${begin_id}")
end_id=$(trim "${end_id}")
#echo "begin_id: $begin_id    end_id: $end_id"
}

#*******************************
# generate AWR report
# *******************************
generate_awr()
{
    if [ $type = "text" ]
    then
        report_name=$LOG_DIR/"awrrpt_$from}_${to}.txt"
    else
        report_name=$LOG_DIR/"awrrpt_${from}_${to}.html"
    fi
#echo $report_name
sqlplus -s / as sysdba >/dev/null<<EOF
            set term off
            define report_type=$type
            define num_days=$day
            define begin_snap=${begin_id}
            define end_snap=${end_id}
            define report_name=${report_name}
            @?/rdbms/admin/awrrpt.sql
            exit;
EOF
}

#*******************************
# main routing
# *******************************
define_dur
generate_awr