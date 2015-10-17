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

for list in ${HOME}/env\_*
do
   V_USER=` cat $list | grep V_USER= | awk -F'=' '{print $2 }' `
   V_PASS=` cat $list | grep V_PASS= | awk -F'=' '{print $2 }' `
   V_DB=` cat $list | grep V_DB= | awk -F'=' '{print $2 }' `

echo DB $V_DB
echo =======================


vsql -h $V_DB  -U $V_USER -w $V_PASS     -v 1="'$param1'" -v 2="'$param2'" -v 3="'$param3'" -v 4="'$param4'"  -f $script
done


