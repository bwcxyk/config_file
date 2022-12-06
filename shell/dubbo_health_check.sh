#!/bin/bash

outputfile=/tmp/dubbo_health_check
dubbo_port=$1

(echo 'status -l'; sleep 1) | nc -w 3 127.0.0.1 ${dubbo_port} > ${outputfile}

result=`grep summary ${outputfile}| awk '{print $4}' `

if [[ "${result}" == "OK" ]] || [[ "${result}" == "WARN" ]]
then
    exit 0
else
    exit 1
fi


#        livenessProbe:
#          exec:
#            command:
#            - /bin/bash
#            - /opt/dubbo_health_check.sh
#            - '20800'
#          initialDelaySeconds: 60
#          timeoutSeconds: 5
#          periodSeconds: 60
#          failureThreshold: 3