#!/bin/bash

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
echo =======================


mysql --ssl --ssl-cipher=AES256-SHA -A -u${V_USER} -p${V_PASS} -h ${V_HOST} -D ${V_DB} -e "set @1:='$param1'; set @2='$param2'; source ${script} ;" 
