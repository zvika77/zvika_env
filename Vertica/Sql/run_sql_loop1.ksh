#!/bin/ksh 



counter=$1
script=$2
param2=$3
param3=$4
param4=$5
param5=$6




watch  --interval=$counter --d  "./run_sql_noecho.ksh $script $param2 $param3 $param4 $param5"
