#!/bin/ksh



script=$1
param1=$2
param2=$3
param3=$4
param4=$5


vsql -i -h $V_DB  -U $V_USER -w $V_PASS  -v 1="'$param1'" -v 2="'$param2'" -v 3="'$param3'" -v 4="'$param4'"  -f $script
