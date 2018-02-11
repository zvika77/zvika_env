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
echo =======================



psql -h $V_DB  -U $V_USER -d $DATABASE -p $PORT -a -b -e -v 1="'$param1'" -v 2="'$param2'" -v 3="'$param3'" -v 4="'$param4'"  -f $script
