#!/bin/bash 



source ${HOME}/env_mysqlprod
mysql -u${V_USER} -p${V_PASS} -h ${V_HOST} -D ${V_DB} -e " source mysql_check_queued_reports_details.sql" -s | awk '{print $1}' | sort | uniq > /tmp/queue_clients.tmp
source ${HOME}/env_dash
for client in $(cat /tmp/queue_clients.tmp); do
echo $client
/Users/zvikagutkin/Vertica/Sql/run_sql_noecho.ksh check_queued_reports.sql $client
done
