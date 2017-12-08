#!/bin/bash
SCRIPT_DIR=/home/oracle/11g/vertica_scripts

set_env()
{
export V_USER=$1
export V_PASS=$2
export V_DB=$3

}


run_report()
{
   echo "From:vertica@liveperson.com">/home/zvikag/Vertica/Log/sendmail.header
   echo "Subject: $V_DB Vertica Health Check Report">>/home/zvikag/Vertica/Log/sendmail.header
#   echo "To: zvikag@liveperson.com">>/home/zvikag/Vertica/Log/sendmail.header
   echo "To: dbaoncall-lp@liveperson.com">>/home/zvikag/Vertica/Log/sendmail.header
   echo "Content-type: text/html">>/home/zvikag/Vertica/Log/sendmail.header

   echo Running Report...

echo $V_DB
   cat /home/zvikag/Vertica/Sql/health_check.sql | /opt/vertica/bin/vsql  -H  -E -U $V_USER -w $V_PASS -h $V_DB  > /home/zvikag/Vertica/Log/health_check_${V_DB}.html


   echo Sending Mail ...

   cat /home/zvikag/Vertica/Log/sendmail.header  /home/zvikag/Vertica/Log/health_check_${V_DB}.html | /usr/sbin/sendmail -t

}


set_env vertica lpbi4u svpr-dbv05
run_report
set_env vertica lpbi4uk  slpr-dbv01
run_report
set_env vertica lpbi4am rapr-dbv01
run_report
set_env vertica lpbi4dr ropr-dbv05
run_report
set_env vertica lp4alpha svor-dbv100
run_report
echo Finished


