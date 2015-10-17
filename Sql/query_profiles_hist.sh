#!/bin/bash
SCRIPT_DIR=/home/zvikag/Vertica/Sql
LOG_DIR=/tmp

set_env()
{
export V_USER=$1
export V_PASS=$2
export V_DB=$3

}


run_hist()
{


   echo moving insert_query_profiles_hist.tmp

   mv ${LOG_DIR}/insert_query_profiles_hist.tmp ${LOG_DIR}/insert_query_profiles_hist.tmp.old


echo $V_DB
   cat ${SCRIPT_DIR}/insert_query_profiles_hist.sql | /opt/vertica/bin/vsql  -U $V_USER -w $V_PASS -h $V_DB -a  --echo-all

echo "checking for errors ..."
   check_sql_error




}

check_sql_error ()
{
   STATUS=`grep -E 'ERROR:|ROLLBACK:' ${LOG_DIR}/insert_query_profiles_hist.tmp | wc -l`
 if [ $STATUS -ne 0 ]
 then
   echo "From:vertica@liveperson.com">${LOG_DIR}/sendmail.header
   echo "Subject: $V_DB Query Profiles Hist ERROR (Check oracle@stm23 crontab)">>${LOG_DIR}/sendmail.header
   echo "To: zvikag@liveperson.com">>${LOG_DIR}/sendmail.header
   echo "Content-type: text/html">>${LOG_DIR}/sendmail.header


   cat ${LOG_DIR}/sendmail.header  ${LOG_DIR}/insert_query_profiles_hist.tmp | /usr/sbin/sendmail -t
 fi

}


set_env vertica lp4alpha svor-dbv100
run_hist
set_env vertica lpbi4u svpr-dbv05
run_hist
set_env vertica lpbi4uk slpr-dbv01
run_hist
echo Finished

