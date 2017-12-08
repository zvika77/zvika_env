#!/bin/bash

SCRIPT_DIR=/home/Vertica

for list in /home/Vertica/Scripts/*.sql
do
   echo "$list"
   echo ""
done

echo -n "Enter full path to sql: "
read source_path

for list in $SCRIPT_DIR/env\_*
do
   echo "$(basename $list)          HOST:  ` cat $list | grep host | awk '{print $2}' ` "

done


echo -n "Enter vertica env: "
read env


#user=`grep user $SCRIPT_DIR/$env | awk '{ print $2 }'`
#pass=`grep pass $SCRIPT_DIR/$env | awk '{ print $2 }'`
#server=`grep host $SCRIPT_DIR/$env | awk '{ print $2 }'`


#export V_USER=${user}
#export V_PASS=${pass}
#export V_DB=${server}

echo "Started Load test on ${V_USER}@${V_DB} ...."

## start dir loop

for sql_path in ${source_path}
do

echo "${sql_path}"
echo `date` > ${sql_path}.time
#cat  ${sql_path} >>  ${sql_path}.time
(echo "explain local verbose " ; cat ${sql_path}) | /opt/vertica/bin/vsql -U $V_USER -w $V_PASS -h $V_DB  >> ${sql_path}.time



# results
(echo "\timing" ; cat ${sql_path}) | /opt/vertica/bin/vsql -U $V_USER -w $V_PASS -h $V_DB >> ${sql_path}.time



echo "Timing : " >> ${sql_path}.time

#for (( ; ; ))
for j in {1..10}
do
  (echo "\timing" ; cat ${sql_path}) | /opt/vertica/bin/vsql -U $V_USER -w $V_PASS -h $V_DB | awk '/^Time:/ {print $6 " " $11 }'  >> ${sql_path}.time
  sleep 1.1
  echo -n "${j} ..."
done
echo ""

echo "Log path: ${sql_path}.time"


done





#!/bin/bash

#echo -n "How many concurrent connection ?"
#read concurrent
#echo -n "Enter sql file to run [full path] ?"
#read sql
#sql=/home/zvikag/Vertica/Sql/1.sql
#sql=/home/zvikag/Vertica/Sql/2.sql
#sql=/home/zvikag/Vertica/Sql/3.sql


#echo "\timing" > /tmp/t.cmd


#for for (( ; ; ))
#for j in {1..10}
#do
#   echo "Loop $j [ hit CTRL+C to stop]"
#
#   for i in {1..15} # how many concurrent connections
#   do
#      echo "#### $j Loop $i "
#     echo "$j cat /tmp/t.cmd $sql | /opt/vertica/bin/vsql -U $V_USER -w $V_PASS -h $V_DB | grep 'Time:' >> time.out #  $sql.out.${j}_$i.tmp 2>&1"
#      #cat /tmp/t.cmd $sql | /opt/vertica/bin/vsql -U $V_USER -w $V_PASS -h $V_DB | grep 'Time:' >> time.out  #  $sql.out.${j}_$i.tmp 2>&1  &
#      cat /tmp/t.cmd $sql | /opt/vertica/bin/vsql -U $V_USER -w $V_PASS -h $V_DB | awk '$1 ~ /Time:/ {print $6 " " "'$j'" " " "'$i'" }'  >> time.out &
#      sleep 3
#   done
#   wait
#
#done
