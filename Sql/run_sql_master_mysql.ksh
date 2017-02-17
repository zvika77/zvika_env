#!/bin/ksh



script=$1
param1=$2
param2=$3
param3=$4
param4=$5


echo =======================
echo Script $script
echo Param1 $param1
echo Param2 $param2
echo Param3 $param3
echo Param4 $param4

for list in $(ls -1 ${HOME}/env\_* | grep mysql | grep -v \#)
do
   V_USER=` cat $list | grep V_USER= | awk -F'=' '{print "echo " $2 }' | bash`
   V_PASS=` cat $list | grep V_PASS= | awk -F'=' '{print "echo " $2 }' | bash`
   V_DB=` cat $list | grep V_DB= | awk -F'=' '{print "echo " $2 }' | bash`
   V_HOST=` cat $list | grep V_HOST= | awk -F'=' '{print "echo " $2 }' | bash`

echo HOST $V_HOST
echo =======================

mysql --ssl -A -u${V_USER} -p${V_PASS} -h ${V_HOST} -D ${V_DB} -e "set @1:='$param1'; set @2='$param2'; source ${script} ;"
done


