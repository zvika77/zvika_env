#!/bin/bash
SCRIPT_DIR=/home/oracle/11g/vertica_scripts
LOG_DIR=/tmp

set_env()
{
export V_USER=$1
export V_PASS=$2
export V_DB=$3

}


run_report()
{
   echo "From:vertica@liveperson.com">${LOG_DIR}/sendmail.header
   echo "Subject: $V_DB Auto Purge">>${LOG_DIR}/sendmail.header
   echo "To: zvikag@liveperson.com">>${LOG_DIR}/sendmail.header
   echo "Content-type: text/html">>${LOG_DIR}/sendmail.header

   echo Running Report...

echo $V_DB
   cat /home/zvikag/Vertica/Sql/automatic_purging.sql | /opt/vertica/bin/vsql  -U $V_USER -w $V_PASS -h $V_DB 


   echo Sending Mail ...

   cat ${LOG_DIR}/sendmail.header  ${LOG_DIR}/automatic_purging.tmp | /usr/sbin/sendmail -t

   echo Removing automatic_purging.tmp

#   rm -f /home/zvikag/Vertica/Sql/automatic_purging.tmp

}


set_env vertica lpbi4u svpr-dbv05
run_report
set_env vertica lpbi4uk slpr-dbv01
run_report
echo Finished


